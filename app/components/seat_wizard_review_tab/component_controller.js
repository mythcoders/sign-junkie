import ApplicationController from "../../javascript/controllers/application_controller"

export default class extends ApplicationController {
  static targets = ["acknowledgment", "disclaimer", "input", "submitMessage"]

  initialize() {
    document.addEventListener('SeatWizard:updateGuestType', function (event) {
      let projectSelected = event.detail.purchaseMode === 'now'

      this.acknowledgmentTargets.forEach(e => e.hidden = !projectSelected)
      this.inputTargets.forEach(e => e.required = projectSelected)
      this.submitMessageTarget.innerHTML = projectSelected ? "Add to cart" : "Invite Guest"
      this.disclaimerTarget.innerHTML = projectSelected ?
        "Please review your project selection. Changes can not be made once your order has been submitted." :
        "Please review your selections and ensure guest information (if any) is entered correctly."

    }.bind(this))
  }
}