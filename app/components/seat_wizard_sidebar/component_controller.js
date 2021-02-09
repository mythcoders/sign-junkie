import ApplicationController from "../../javascript/controllers/application_controller"
import Api from "../../javascript/libraries/api"

export default class extends ApplicationController {
  static targets = ["content", "template", "guestPaymentClause", "updateError"]

  connect() {
    this.registerCallbacks()
  }

  refresh(data) {
    if (data.project_id !== undefined) {
      Api.sidebar(data.project_id, data.addon_id, data.stencils)
        .then(resp => {
          this.contentTarget.innerHTML = resp.data
        })
        .catch(err => {
          console.error(err)
          this.contentTarget.innerHTML = this.updateErrorTarget.innerHTML
        })
    }

    if (this.hasGuestPaymentClauseTarget) {
      this.guestPaymentClauseTarget.hidden = data.purchaseMode === 'now'
    }
  }

  reset() {
    this.contentTarget.innerHTML = this.templateTarget.innerHTML
  }

  // private

  registerCallbacks() {
    document.addEventListener('SeatWizard:reset', function (event) {
      this.reset()
    }.bind(this))

    document.addEventListener('SeatWizard:refreshSidebar', function (event) {
      this.refresh(event.detail)
    }.bind(this))
  }
}