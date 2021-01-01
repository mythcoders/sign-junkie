import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  disableOnSubmit(e) {
    e.eventTarget.disabled = true
  }
}