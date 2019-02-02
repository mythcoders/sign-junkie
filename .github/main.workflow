workflow "Deploy to Heroku" {
  on = "push"
  resolves = [
    "verify-test",
    "verify-production"
  ]
}

action "tag" {
  uses = "actions/bin/sh@master"
  args = ["./scripts/ci_tag.sh"]
}

action "build" {
  needs = ["tag"]
  uses = "actions/docker/cli@master"
  args = "build -t sign-junkie-app ."
}

action "assets" {
  needs = ["build"]
  uses = "docker://ruby:2.5.1-alpine"
  args = ["./scripts/ci_assets.sh"]
  env = {
    RAILS_ENV = "qa"
    ASSETS_BUCKET = "mcdig-qacdn-signjunkie.sfo2"
  }
}

action "login" {
  uses = "actions/heroku@master"
  args = "container:login"
  secrets = ["HEROKU_API_KEY"]
}

action "push-test" {
  needs = ["login", "build"]
  uses = "actions/heroku@master"
  args = ["container:push", "web", "--app", "$HEROKU_APP"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-qa"
  }
}

action "db-test" {
  needs = ["push-test"]
  uses = "actions/heroku@master"
  args = ["run", "bundle", "exec", "rails", "db:seed", "db:migrate", "--type", "web", "--app", "$HEROKU_APP"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-qa"
  }
}

action "release-test" {
  needs = ["db-test"]
  uses = "actions/heroku@master"
  args = ["container:release", "--app", "$HEROKU_APP", "web"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-qa"
  }
}

action "verify-test" {
  needs = ["release-test"]
  uses = "actions/heroku@master"
  args = ["apps:info", "$HEROKU_APP"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-qa"
  }
}

action "master-branch-filter" {
  needs = ["verify-test"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "push-production" {
  needs = ["master-branch-filter"]
  uses = "actions/heroku@master"
  args = ["./scripts/cibuild"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-pd"
  }
}

action "db-production" {
  needs = ["master-branch-filter"]
  uses = "actions/heroku@master"
  args = ["run", "bundle", "exec", "rails", "db:seed", "db:migrate", "--type", "web", "--app", "$HEROKU_APP"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-pd"
  }
}

action "release-production" {
  needs = ["push-production", "db-production"]
  uses = "actions/heroku@master"
  args = ["container:release", "--app", "$HEROKU_APP", "web"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-pd"
  }
}

action "verify-production" {
  needs = ["release-production"]
  uses = "actions/heroku@master"
  args = ["apps:info", "$HEROKU_APP"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-pd"
  }
}
