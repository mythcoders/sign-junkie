# Ares

Ares is an open-source business management system that is built on the Rails platform and can be customized to help you manage almost every aspect of your business!

## Services Used

- Sentry
- Braintree (with client credentials)
- PostgreSQL

## Getting Started

- Get the encryption key file from a fellow developer. Without it, you will not be able to launch the application. It must be placed in `/config/master.key`
- Run via `docker compose`

### Running RSpec

From the root directory: `bundle exec rspec`

If you receive an error about a database not existing, you may also need to run: `RAILS_ENV=test bundle exec rails db:create`

## Popular Links

- [Datetime picker docs](https://tempusdominus.github.io/bootstrap-4/)
