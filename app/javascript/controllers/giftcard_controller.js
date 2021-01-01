import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = ["selectedAmount"]

  setAmount(event) {
    this.selectedAmountTarget.value = event.target.dataset.amount
  }
}