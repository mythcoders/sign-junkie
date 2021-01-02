import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))

import 'bootstrap/dist/js/bootstrap.bundle.min'
import 'flatpickr/dist/flatpickr'
import 'helpers/sentry_helpers'

// document.addEventListener('turbo:load', () => {

// })