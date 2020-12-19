import AdminController from "./admin_controller"

export default class extends AdminController {
  static targets = ["selectedAmount"]

  setAmount(event) {
    this.selectedAmountTarget.value = event.target.dataset.amount
  }
}