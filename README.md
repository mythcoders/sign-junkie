# Ares CRM

Ares is an open-source Customer Relationship Management System that is built on the ails platform. Originally built for WHIZ Media and Sign Junkie, it can be customized to help you manage almost every aspect of your business!

## Services Used

- LogDNA
- Sentry
- Braintree (with client credentials)
- PostgreSQL

## Getting Started

- Get the encryption key file from a fellow developer. Without it, you will not be able to launch the application. It must be placed in `/config/master.key`

### Running RSpec

From the root directory: `bundle exec rspec`

If you receive an error about a database not existing, you may also need to run: `RAILS_ENV=test bundle exec rails db:create`

## Popular Links

- [Datetime picker docs](https://tempusdominus.github.io/bootstrap-4/)
