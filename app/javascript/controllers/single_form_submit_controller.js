import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  disableOnSubmit(e) {
    e.target.disabled = true
    e.target.form.submit()
  }
}