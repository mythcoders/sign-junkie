job "sign-junkie" {
  datacenters = ["mcdig"]

  meta {
    run_id = "${uuidv4()}"
  }

  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "20s"
    healthy_deadline  = "3m"
    progress_deadline = "10m"
    auto_revert       = true
    auto_promote      = true
    canary            = 1
    stagger           = "30s"
  }

  group "app" {
    constraint {
      attribute = "${node.class}"
      operator  = "="
      value     = "app"
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
      name = "sign-junkie-rails"
      port = "puma"

      tags = [
        "traefik.enable=true",
        "traefik.consulcatalog.connect=true",
        "traefik.http.routers.sign-junkie-http.rule=Host(`signjunkieworkshop.com`) || Host(`www.signjunkieworkshop.com`)",
        "traefik.http.routers.sign-junkie-http.entrypoints=web",
        "traefik.http.routers.sign-junkie-http.priority=90",
        "traefik.http.routers.sign-junkie-http.middlewares=https-upgrade@file",
        "traefik.http.routers.sign-junkie-https.rule=Host(`signjunkieworkshop.com`) || Host(`www.signjunkieworkshop.com`)",
        "traefik.http.routers.sign-junkie-https.middlewares=www-redirect@file",
        "traefik.http.routers.sign-junkie-https.entrypoints=webSecure",
        "traefik.http.routers.sign-junkie-https.priority=90",
        "traefik.http.routers.sign-junkie-https.tls=true",
        "traefik.http.routers.sign-junkie-https.tls.certresolver=letsEncrypt",
      ]

      canary_tags = [
        "traefik.enable=false",
        "traefik.consulcatalog.connect=true",
      ]

      connect {
        sidecar_service {
          proxy {
            local_service_address = "0.0.0.0"
            local_service_port = 5000
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

      resources {
        cpu    = 1000
        memory = 512
        memory_max = 1500
      }

      config {
        image = "ghcr.io/mythcoders/sign-junkie:main"
        ports = ["puma"]
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      DATABASE_URL="{{ key "sign-junkie/database-url" }}"
      CDN_URL="https://cdn.signjunkieworkshop.com"
      REDIS_URL="{{ key "sign-junkie/redis-url" }}"
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
        image = "ghcr.io/mythcoders/sign-junkie:main"
        entrypoint = ["sh", "./scripts/db"]
        ports = ["puma"]
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      DATABASE_URL="{{ key "sign-junkie/database-url" }}"
      CDN_URL="https://cdn.signjunkieworkshop.com"
      REDIS_URL="{{ key "sign-junkie/redis-url" }}"
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
      name = "sign-junkie-sidekiq"
    }

    task "sidekiq" {
      driver = "docker"

      resources {
        cpu    = 1500
        memory = 512
        memory_max = 1500
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      DATABASE_URL="{{ key "sign-junkie/database-url" }}"
      CDN_URL="https://cdn.signjunkieworkshop.com"
      REDIS_URL="{{ key "sign-junkie/redis-url" }}"
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
        image = "ghcr.io/mythcoders/sign-junkie:main"
        entrypoint = ["sh", "./scripts/worker", "start"]
      }
    }
  }
}
