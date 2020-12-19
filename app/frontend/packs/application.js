// This file is automatically compiled by Webpack, along with any other files present in this directory.

import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()

const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// require('trix/dist/trix.css')
require('flatpickr/dist/flatpickr.css')
// require('tiny-slider/dist/tiny-slider.css')
require("../stylesheets/application.scss")
require("../fonts/feather/feather.css")

const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

import 'bootstrap/dist/js/bootstrap.bundle.min'
import 'flatpickr/dist/flatpickr'

document.addEventListener('turbolinks:load', () => {
  console.log('turbolinks loaded')
  require('lib/theme')
})
