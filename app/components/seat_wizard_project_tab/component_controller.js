import ApplicationController from "../../javascript/controllers/application_controller"

export default class extends ApplicationController {
  static values = { projectId: String, hasAddons: Boolean }
  static targets = ["option", "input", "nextButton"]
  static classes = ["active", "disabled"]

  toggle(e) {
    e.preventDefault()

    this.projectIdValue = e.currentTarget.dataset.id
    this.hasAddonsValue = e.currentTarget.dataset.activeAddons !== undefined

    this.inputTarget.value = this.projectIdValue
    this.nextButtonTarget.classList.remove(this.disabledClass)
    if (this.hasAddonsValue) {
      this.nextButtonTarget.dataset.destination = 'addon'
    } else {
      this.nextButtonTarget.dataset.destination = 'stencil'
    }

    this.optionTargets.forEach((element) => {
      if (element.dataset.id === this.projectIdValue) {
        element.classList.add(this.activeClass)
      } else {
        element.classList.remove(this.activeClass)
      }
    })

    this.notifySeatWizard()
  }

  notifySeatWizard() {
    document.dispatchEvent(new CustomEvent('SeatWizard:updateProject', {
      detail: {
        id: this.projectIdValue,
        addons: this.hasAddonsValue
      }
    }))
  }
}