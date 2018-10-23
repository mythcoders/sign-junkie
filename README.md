# Sign Junkie Online Store

[![Zoho CRM Account](https://img.shields.io/badge/crm-view%20account-blue.svg)](https://crm.zoho.com/crm/org655012981/tab/Accounts/2822694000000216059/)
[![View QA](https://img.shields.io/badge/app-view%20qa-yellowgreen.svg)](http://qa.signjunkieworkshop.com/)
[![View Production](https://img.shields.io/badge/app-view%20prod-orange.svg)](https://http://signjunkieworkshop.com/)

eCommerce website for [Sign Junkie Workshop](https://www.whiznews.com/) in Thornville, OH.

Built on the Rails platform, Sign Junkie allows Admin users to create events where tickets can be sold on public facing pages. Customers then use Braintree to pay with PayPal and complete their purchases.

## Services Used

- SendGrid
- LogDNA
- Sentry
- Braintree (with client credentials)
- PostgreSQL
- Heroku

## Getting Started

- Get the encryption key file from a fellow developer. Without it, you will not be able to launch the application. It must be placed in `/config/master.key`

**If connecting to a MythCoders database**

- Get a database certificate from a fellow developer. It must be placed in `/config/db.crt`

### Default Configurations

**Never** store secret information in the `.env` file **if** it's going to be committed to source control. In that case, they should be stored in the encrypted credentials file, `/config/credentials.yml.enc`

```
RAILS_ENV=development
RACK_ENV=development
PAYMENT_ENV=sandbox
LANG=en_US.UTF-8
RAILS_SERVE_STATIC_FILES=enabled
RAILS_LOG_TO_STDOUT=enabled
STORAGE_BUCKET=mcdig-dvstg-signjunkie
DATABASE_URL='postgres://postgres:postgres@0.0.0.0:5432/sign_junkie_dev'
```

### Running RSpec

From the root directory: `bundle exec rspec`

If you receive an error about a database not existing, you may also need to run: `RAILS_ENV=test bundle exec rails db:create`

Note, you can always create a `.env.test` file to specify a database to connect to. It's been added to `.gitignore`, but you should make sure to never commit this file.

## Popular Links

- [Datetime picker docs](https://tempusdominus.github.io/bootstrap-4/)
