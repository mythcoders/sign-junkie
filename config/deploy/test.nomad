job "sign-junkie-pr343" {
  name = "sign-junkie"
  datacenters = ["nyc1"]

  meta {
    id = "pr-343"
    image = "pr-343"
  }

  group "app" {
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

    service {
      name = "${NOMAD_JOB_NAME}-rails"
      port = "puma"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.sign-junkie.rule=Host(`${meta.id}.test.signjunkieworkshop.com`)",
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
        image = "ghcr.io/mythcoders/sign-junkie:${meta.image}"
        ports = ["puma"]
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      HERMES_API_KEY="{{ key "sign-junkie/hermes-key" }}"
      HERMES_API_SECRET="{{ key "sign-junkie/hermes-secret" }}"
      DATABASE_URL="{{ key "sign-junkie/database-url" }}"
      REDIS_URL = "redis://127.0.0.1:6379/0"
      ENVIRONMENT_NAME="review/{{ env "meta.id" }}"
      ENVIRONMENT_URL="https://{{ env "meta.id" }}.test.signjunkieworkshop.com"
      PAYMENT_ENV="sandbox"
      RAILS_ENV="review"
      RAILS_LOG_TO_STDOUT="1"
      RAILS_SERVE_STATIC_FILES="1"
      REDIS_NAMESPACE="sign-junkie"
      STORAGE_BUCKET="mcdig-rvstg-com1"
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
        image = "ghcr.io/mythcoders/sign-junkie:${meta.image}"
        entrypoint = ["./bin/rails", "db:create", "db:migrate"]
        ports = ["puma"]
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      HERMES_API_KEY="{{ key "sign-junkie/hermes-key" }}"
      HERMES_API_SECRET="{{ key "sign-junkie/hermes-secret" }}"
      DATABASE_URL="{{ key "sign-junkie/database-url" }}"
      REDIS_URL = "redis://127.0.0.1:6379/0"
      ENVIRONMENT_NAME="review/{{ env "meta.id" }}"
      ENVIRONMENT_URL="https://{{ env "meta.id" }}.test.signjunkieworkshop.com"
      PAYMENT_ENV="sandbox"
      RAILS_ENV="review"
      RAILS_LOG_TO_STDOUT="1"
      RAILS_SERVE_STATIC_FILES="1"
      REDIS_NAMESPACE="sign-junkie"
      STORAGE_BUCKET="mcdig-rvstg-com1"
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
      REDIS_URL = "redis://127.0.0.1:6379/0"
      ENVIRONMENT_NAME="review/{{ env "meta.id" }}"
      ENVIRONMENT_URL="https://{{ env "meta.id" }}.test.signjunkieworkshop.com"
      PAYMENT_ENV="sandbox"
      RAILS_ENV="review"
      RAILS_LOG_TO_STDOUT="1"
      RAILS_SERVE_STATIC_FILES="1"
      REDIS_NAMESPACE="sign-junkie"
      STORAGE_BUCKET="mcdig-rvstg-com1"
      EOH

        destination = "secrets/sidekiq.env"
        env         = true
      }

      config {
        image = "ghcr.io/mythcoders/sign-junkie:${meta.image}"
        entrypoint = ["sh", "./scripts/worker", "start"]
      }
    }
  }
}
