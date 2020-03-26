# Apollo

Apollo is an open-source business management system that is designed to be customizable for your business needs.

## Software stack

- Ruby (MRI) 2.6.3
- PostgreSQL
- Redis 2.8+

### Services used

- Sentry
- Braintree (with client credentials)

## Getting Started

1. Populate `master.key`
2. Pull `mythcoders/gaia:latest` docker image
3. Run `docker-compose up`

## Workers

| Name | Runtime |
| --- | --- |
| `CartCleanupWorker` | Daily 04:15 |
| `PaymentDeadlineWorker` | Daily 04:30 |
| `RegistrationDeadlineWorker` | Daily 04:30 |
| `ReservationDepositRefundWorker` | Daily 05:00 |
| `AbandonedCartReminderWorker` | Daily 06:00 |
| `PaymentDeadlineReminderWorker` | Daily 06:00 |
| `RegistrationDeadlineReminderWorker` | Daily 06:00 |
| `UnconfirmedAccountReminderWorker` | Daily 06:00 |
