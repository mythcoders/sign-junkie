import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = ["tab"]

  next() {
    // remove active class from current index
    // apply to index + 1
  }

  previous() {
    // remove active class
    // apply to new one
  }
}