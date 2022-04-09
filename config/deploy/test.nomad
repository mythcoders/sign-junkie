job "sign-junkie-pr-PR_NUMBER" {
  datacenters = ["mcdig"]

  meta {
    github_run_id = "RUN_ID"
    github_pr = "pr-PR_NUMBER"
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

    service {
      name = "${NOMAD_JOB_NAME}-rails"
      port = "puma"

      tags = [
        "traefik.enable=true",
        "traefik.consulcatalog.connect=true",
        "traefik.http.routers.${NOMAD_JOB_NAME}-http.rule=Host(`${NOMAD_META_github_pr}.test.signjunkieworkshop.com`)",
        "traefik.http.routers.${NOMAD_JOB_NAME}-http.entrypoints=web",
        "traefik.http.routers.${NOMAD_JOB_NAME}-http.priority=100",
        "traefik.http.routers.${NOMAD_JOB_NAME}-http.middlewares=https-upgrade@file",
        "traefik.http.routers.${NOMAD_JOB_NAME}-https.rule=Host(`${NOMAD_META_github_pr}.test.signjunkieworkshop.com`)",
        "traefik.http.routers.${NOMAD_JOB_NAME}-https.entrypoints=webSecure",
        "traefik.http.routers.${NOMAD_JOB_NAME}-https.priority=100",
        "traefik.http.routers.${NOMAD_JOB_NAME}-https.tls=true",
        "traefik.http.routers.${NOMAD_JOB_NAME}-https.tls.certresolver=letsEncrypt",
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

            upstreams {
              destination_name = "redis"
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

    task "db-migrate" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      driver = "docker"

      config {
        image = "ghcr.io/mythcoders/sign-junkie:${NOMAD_META_github_pr}"
        entrypoint = ["./bin/rails", "db:create", "db:migrate"]
        ports = ["puma"]
        force_pull = true
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      HERMES_API_KEY="{{ key "sign-junkie/hermes-key" }}"
      HERMES_API_SECRET="{{ key "sign-junkie/hermes-secret" }}"
      DATABASE_URL="{{ key "apps/database-url" }}//{{ env "NOMAD_JOB_NAME" }}"
      REDIS_URL = "redis://127.0.0.1:6379/0"
      ENVIRONMENT_NAME="review/{{ env "NOMAD_META_github_pr" }}"
      ENVIRONMENT_URL="https://{{ env "NOMAD_META_github_pr" }}.test.signjunkieworkshop.com"
      PAYMENT_ENV="sandbox"
      RAILS_ENV="review"
      RAILS_LOG_TO_STDOUT="1"
      RAILS_SERVE_STATIC_FILES="1"
      REDIS_NAMESPACE="sign-junkie"
      STORAGE_BUCKET="mcdig-rvstg-com1"
      CDN_URL="https://cdn.test.signjunkieworkshop.com"
      EOH

        destination = "secrets/file.env"
        env         = true
      }
    }

    task "rails" {
      driver = "docker"

      config {
        image = "ghcr.io/mythcoders/sign-junkie:${NOMAD_META_github_pr}"
        ports = ["puma"]
        force_pull = true
      }

      resources {
        cpu    = 850
        memory = 512
        memory_max = 1000
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      HERMES_API_KEY="{{ key "sign-junkie/hermes-key" }}"
      HERMES_API_SECRET="{{ key "sign-junkie/hermes-secret" }}"
      DATABASE_URL="{{ key "apps/database-url" }}//{{ env "NOMAD_JOB_NAME" }}"
      REDIS_URL = "redis://127.0.0.1:6379/0"
      ENVIRONMENT_NAME="review/{{ env "NOMAD_META_github_pr" }}"
      ENVIRONMENT_URL="https://{{ env "NOMAD_META_github_pr" }}.test.signjunkieworkshop.com"
      PAYMENT_ENV="sandbox"
      RAILS_ENV="review"
      RAILS_LOG_TO_STDOUT="1"
      RAILS_SERVE_STATIC_FILES="1"
      REDIS_NAMESPACE="sign-junkie"
      STORAGE_BUCKET="mcdig-rvstg-com1"
      CDN_URL="https://cdn.test.signjunkieworkshop.com"
      EOH

        destination = "secrets/rails.env"
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

    service {
      name = "${NOMAD_JOB_NAME}-sidekiq"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "redis"
              local_bind_address = "127.0.0.1"
              local_bind_port  = 6379
            }
          }
        }
      }
    }

    task "sidekiq" {
      driver = "docker"

      config {
        image = "ghcr.io/mythcoders/sign-junkie:${NOMAD_META_github_pr}"
        entrypoint = ["sh", "./scripts/worker", "start"]
        force_pull = true
      }

      kill_timeout = "30s"

      resources {
        cpu    = 750
        memory = 512
        memory_max = 750
      }

      template {
        data = <<EOH
      RAILS_MASTER_KEY="{{ key "sign-junkie/rails-master-key" }}"
      HERMES_API_KEY="{{ key "sign-junkie/hermes-key" }}"
      HERMES_API_SECRET="{{ key "sign-junkie/hermes-secret" }}"
      DATABASE_URL="{{ key "apps/database-url" }}//{{ env "NOMAD_JOB_NAME" }}"
      REDIS_URL="redis://127.0.0.1:6379/0"
      ENVIRONMENT_NAME="review/{{ env "NOMAD_META_github_pr" }}"
      ENVIRONMENT_URL="https://{{ env "NOMAD_META_github_pr" }}.test.signjunkieworkshop.com"
      PAYMENT_ENV="sandbox"
      RAILS_ENV="review"
      RAILS_LOG_TO_STDOUT="1"
      RAILS_SERVE_STATIC_FILES="1"
      REDIS_NAMESPACE="sign-junkie"
      STORAGE_BUCKET="mcdig-rvstg-com1"
      CDN_URL="https://cdn.test.signjunkieworkshop.com"
      EOH

        destination = "secrets/sidekiq.env"
        env         = true
      }
    }
  }
}
