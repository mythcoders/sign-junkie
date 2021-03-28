import * as Sentry from "@sentry/browser"

let errorDsn = document.querySelector("meta[name='sign-junkie-error-dsn']")?.content

if (errorDsn !== '') {
  let env = document.querySelector("meta[name='sign-junkie-environment']")?.content
  let release = document.querySelector("meta[name='sign-junkie-release']")?.content

  Sentry.init({
    dsn: errorDsn,
    environment: env,
    release: "sign-junkie@" + release,
    tracesSampleRate: env == "production" ? 0.5 : 1.0,
    beforeSend(event, hint) {
      const error = hint.originalException
      if (error &&
        error.message &&
        error.message.match('Fetch is aborted')) {

        return null
      }

      // Check if it is an exception, and if so, show the report dialog
      if (event.exception) {
        Sentry.showReportDialog({ eventId: event.event_id })
      }
      return event
    },
  })

  document.addEventListener('turbo:load', () => {
    let userInfo = document.querySelector("meta[name='sign-junkie-current-user']")?.content

    if (userInfo !== '') { Sentry.setUser(JSON.parse(userInfo)) }
  })
}
