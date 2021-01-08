import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /.js$/)
const context_components = require.context("../components", true, /_controller.js$/)
application.load(
  definitionsFromContext(context).concat(
    definitionsFromContext(context_components)
  )
)

import Flatpickr from 'stimulus-flatpickr'
application.register('flatpickr', Flatpickr)

import 'bootstrap/dist/js/bootstrap.bundle.min'
import 'helpers/sentry_helpers'

// document.addEventListener('turbo:load', () => {

// })