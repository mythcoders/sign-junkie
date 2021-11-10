job "sign-junkie" {
  datacenters = ["nyc1"]

  meta {
    id = "master"
    image = "master"
  }

  group "app" {
    update {
      max_parallel      = 1
      health_check      = "task_states"
      min_healthy_time  = "15s"
      healthy_deadline  = "2m"
      progress_deadline = "10m"
      auto_revert       = true
      auto_promote      = true
      canary            = 1
      stagger           = "20s"
    }

    constraint {
      attribute = "${node.class}"
      operator  = "!="
      value     = "web"
    }

    network {
      mode = "bridge"
      port "puma" {
        to = 5000
      }
    }

    scaling {
      min     = 1
      max     = 3
      enabled = true

      policy {
        evaluation_interval = "5s"
        cooldown            = "1m"

        check "cpu" {
          source = "nomad-apm"
          query  = "avg_cpu"

          strategy "threshold" {
            upper_bound = 80
            delta = 1
          }
        }

        check "mem" {
          source = "nomad-apm"
          query  = "avg_memory"

          strategy "threshold" {
            upper_bound = 80
            delta = 1
          }
        }
      }
    }

    service {
      name = "${NOMAD_JOB_NAME}-rails"
      port = "puma"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.sign-junkie.rule=Host(`signjunkieworkshop.com`) || Host(`www.signjunkieworkshop.com`)",
        "traefik.http.routers.sign-junkie.tls=true",
        "traefik.http.routers.sign-junkie.tls.certresolver=letsEncrypt",
      ]

      connect {
        sidecar_service {
          proxy {
            local_service_address = "0.0.0.0"
            local_service_port = 5000

            upstreams {
              destination_name = "${NOMAD_JOB_NAME}-redis"
              local_bind_address = "127.0.0.1"
              local_bind_port  = 6379
            }

            upstreams {
              destination_name = "hermes-rails"
              local_bind_address = "127.0.0.1"
              local_bind_port  = 1000
            }
          }
        }
      }

      check {
        name     = "heartbeat"
        type     = "http"
        path     = "/_heartbeat"
        interval = "10s"
        timeout  = "3s"
      }
    }

    task "rails" {
      driver = "docker"

      config {
        image = "ghcr.io/mythcoders/sign-junkie:master"
        ports = ["puma"]
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      HERMES_API_KEY="{{ key "sign-junkie/hermes-key" }}"
      HERMES_API_SECRET="{{ key "sign-junkie/hermes-secret" }}"
      DATABASE_URL="{{ key "sign-junkie/database-url" }}"
      CDN_URL="https://assets.signjunkieworkshop.com"
      HERMES_URL="http://127.0.0.1:1000/api/"
      REDIS_URL="redis://127.0.0.1:6379/0"
      ENVIRONMENT_NAME="production"
      ENVIRONMENT_URL="https://signjunkieworkshop.com"
      PAYMENT_ENV="production"
      NODE_ENV="production"
      RAILS_ENV="production"
      RAILS_LOG_TO_STDOUT="1"
      RAILS_SERVE_STATIC_FILES="1"
      REDIS_NAMESPACE="sign-junkie"
      STORAGE_BUCKET="mcdig-pdstg-signjunkie"
      EOH

        destination = "secrets/rails.env"
        env         = true
      }
    }

    task "db-migrate" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      driver = "docker"

      config {
        image = "ghcr.io/mythcoders/sign-junkie:master"
        entrypoint = ["./bin/rails", "db:migrate"]
        ports = ["puma"]
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      HERMES_API_KEY="{{ key "sign-junkie/hermes-key" }}"
      HERMES_API_SECRET="{{ key "sign-junkie/hermes-secret" }}"
      DATABASE_URL="{{ key "sign-junkie/database-url" }}"
      CDN_URL="https://assets.signjunkieworkshop.com"
      HERMES_URL="http://127.0.0.1:1000/api/"
      REDIS_URL="redis://127.0.0.1:6379/0"
      ENVIRONMENT_NAME="production"
      ENVIRONMENT_URL="https://signjunkieworkshop.com"
      PAYMENT_ENV="production"
      NODE_ENV="production"
      RAILS_ENV="production"
      RAILS_LOG_TO_STDOUT="1"
      RAILS_SERVE_STATIC_FILES="1"
      REDIS_NAMESPACE="sign-junkie"
      STORAGE_BUCKET="mcdig-pdstg-signjunkie"
      EOH

        destination = "secrets/file.env"
        env         = true
      }
    }
  }

  group "cache" {
    constraint {
      attribute = "${node.class}"
      operator  = "!="
      value     = "job"
    }

    network {
      mode = "bridge"
      port "redis" {
        to = 6379
      }
    }

    ephemeral_disk {
      migrate = true
      size    = 512
      sticky  = true
    }

    service {
      name = "${NOMAD_JOB_NAME}-redis"
      port = 6739

      connect {
        sidecar_service {
          proxy {
            local_service_address = "127.0.0.1"
            local_service_port = 7777
          }
        }
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:6.2-alpine"
        entrypoint = [ "redis-server", "--port", "7777", "--bind", "127.0.0.1" ]
        ports = ["redis"]
        auth_soft_fail = true
      }

      resources {
        memory = 20
        memory_max = 256
      }
    }
  }

  group "workers" {
    constraint {
      attribute = "${node.class}"
      operator  = "="
      value     = "job"
    }

    network {
      mode = "bridge"
    }

    ephemeral_disk {
      migrate = true
      size    = 512
      sticky  = true
    }

    service {
      name = "${NOMAD_JOB_NAME}-sidekiq"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "${NOMAD_JOB_NAME}-redis"
              local_bind_address = "127.0.0.1"
              local_bind_port  = 6379
            }

            upstreams {
              destination_name = "hermes-rails"
              local_bind_address = "127.0.0.1"
              local_bind_port  = 1000
            }
          }
        }
      }
    }

    task "sidekiq" {
      driver = "docker"

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      HERMES_API_KEY="{{ key "sign-junkie/hermes-key" }}"
      HERMES_API_SECRET="{{ key "sign-junkie/hermes-secret" }}"
      DATABASE_URL="{{ key "sign-junkie/database-url" }}"
      CDN_URL="https://assets.signjunkieworkshop.com"
      HERMES_URL="http://127.0.0.1:1000/api/"
      REDIS_URL="redis://127.0.0.1:6379/0"
      ENVIRONMENT_NAME="production"
      ENVIRONMENT_URL="https://signjunkieworkshop.com"
      PAYMENT_ENV="production"
      NODE_ENV="production"
      RAILS_ENV="production"
      RAILS_LOG_TO_STDOUT="1"
      RAILS_SERVE_STATIC_FILES="1"
      REDIS_NAMESPACE="sign-junkie"
      STORAGE_BUCKET="mcdig-pdstg-signjunkie"
      EOH

        destination = "secrets/sidekiq.env"
        env         = true
      }

      config {
        image = "ghcr.io/mythcoders/sign-junkie:master"
        entrypoint = ["sh", "./scripts/worker", "start"]
      }
    }
  }
}
