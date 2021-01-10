import ApplicationController from "../../javascript/controllers/application_controller"

export default class extends ApplicationController {
  static values = { addonId: String }
  static targets = ["addon", "input"]
  static classes = ["active"]

  toggle(e) {
    e.preventDefault()

    this.addonIdValue = e.currentTarget.dataset.id
    this.notifySeatWizard()
  }

  addonIdValueChanged() {
    this.inputTarget.value = this.addonIdValue
    this.addonTargets.forEach((element) => {
      if (element.dataset.id === this.addonIdValue) {
        element.classList.add(this.activeClass)
      } else {
        element.classList.remove(this.activeClass)
      }
    })
  }

  // private

  notifySeatWizard() {
    document.dispatchEvent(new CustomEvent('SeatWizard:updateAddon', {
      detail: {
        id: this.addonIdValue
      }
    }))
  }
}