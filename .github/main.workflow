workflow "Deploy to Heroku" {
  on = "push"
  resolves = [
    "verify-test",
    "verify-production"
  ]
}

action "build" {
  uses = "actions/docker/cli@master"
  args = "build -t sign-junkie-app ."
}

#action "rspec" {
#  needs = ["build"]
#  uses = "actions/bin/sh@master"
#  args = ["./scripts/cibuild"]
#}

# Login
action "login" {
  uses = "actions/heroku@master"
  args = "container:login"
  secrets = ["HEROKU_API_KEY"]
}

# Push
action "push-test" {
  needs = ["build", "login"]
  uses = "actions/heroku@master"
  args = ["container:push", "--app", "$HEROKU_APP", "web"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-qa"
  }
}

# Migrate
action "db-test" {
  needs = ["build", "login"]
  uses = "actions/heroku@master"
  args = ["run", "bundle", "exec", "rails", "db:migrate", "--type", "web", "--app", "$HEROKU_APP"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-qa"
  }
}

# Release
action "release-test" {
  needs = ["push-test", "db-test"]
  uses = "actions/heroku@master"
  args = ["container:release", "--app", "$HEROKU_APP", "web"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-qa"
  }
}

# Verify
action "verify-test" {
  needs = ["release-test"]
  uses = "actions/heroku@master"
  args = ["apps:info", "$HEROKU_APP"]
  secrets = ["HEROKU_API_KEY"]
  env = {
    HEROKU_APP = "sign-junkie-qa"
  }
}

# Push to master
action "master-branch-filter" {
  needs = ["verify-test"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "push-production" {
  needs = ["master-branch-filter"]
  uses = "actions/heroku@master"
  args = ["container:push", "--app", "$HEROKU_APP", "web"]
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

action "db-production" {
  needs = ["master-branch-filter"]
  uses = "actions/heroku@master"
  args = ["run", "bundle", "exec", "rails", "db:migrate", "--type", "web", "--app", "$HEROKU_APP"]
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
