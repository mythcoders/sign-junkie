import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
application.load(definitionsFromContext(context))

const images = require.context('images', true)
const imagePath = (name) => images(name, true)

import 'bootstrap/dist/js/bootstrap.bundle.min'
import 'flatpickr/dist/flatpickr'

// Raven.config("#{}").install();

document.addEventListener('turbolinks:load', () => {
  require('lib/vendor')
})