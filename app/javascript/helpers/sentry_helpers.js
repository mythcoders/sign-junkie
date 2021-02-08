import * as Sentry from "@sentry/browser"

let errorDsn = document.querySelector("meta[name='sign-junkie-error-dsn']")?.content
let env = document.querySelector("meta[name='sign-junkie-environment']")?.content
let version = document.querySelector("meta[name='sign-junkie-version']")?.content

if (errorDsn !== '') {
  Sentry.init({
    dsn: errorDsn,
    environment: env,
    release: "sign-junkie@" + version,
    tracesSampleRate: env == "production" ? 0.5 : 1.0,
  })

  document.addEventListener('turbo:load', () => {
    let userInfo = document.querySelector("meta[name='sign-junkie-current-user']")?.content

    if (userInfo !== '') {
      Sentry.setUser(JSON.parse(userInfo))
    }
  })
}