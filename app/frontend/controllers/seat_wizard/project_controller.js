import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static values = { projectId: String, projectHasAddons: Boolean }
  static targets = ["project"]
  static classes = ["active"]


  toggle(e) {
    e.preventDefault()

    this.projectIdValue = e.currentTarget.dataset.id
    this.projectHasAddonsValue = e.currentTarget.dataset.activeAddons !== undefined

    this.projectTargets.forEach((element) => {
      if (element.dataset.id === this.projectIdValue) {
        element.classList.add(this.activeClass)
      } else {
        element.classList.remove(this.activeClass)
      }
    })

    this.notifySeatWizard()
  }

  notifySeatWizard() {
    document.dispatchEvent(new CustomEvent('seatWizard.updateProject', {
      detail: {
        id: this.projectIdValue,
        addons: this.projectHasAddonsValue
      }
    }))
  }
}