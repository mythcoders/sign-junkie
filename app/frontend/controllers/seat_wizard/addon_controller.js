import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static values = { addonId: String }
  static targets = ["addon"]
  static classes = ["active"]


  toggle(e) {
    e.preventDefault()

    let element = e.currentTarget
    element.dataset.selected = !element.dataset.selected
    this.addonIdValue = element.dataset.id

    this.addonTargets.forEach((element) => {
      if (element.dataset.id === this.addonIdValue) {
        element.classList.add(this.activeClass)
      } else {
        element.classList.remove(this.activeClass)
      }
    })

    this.notifySeatWizard()
  }

  // private

  notifySeatWizard() {
    document.dispatchEvent(new CustomEvent('seatWizard.updateAddon', {
      detail: {
        id: this.addonIdValue
      }
    }))
  }
}