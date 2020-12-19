import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static classes = ["active"]
  static targets = [
    "addon"
  ]
  static values = {
    addonId: String
  }

  toggle(e) {
    let element = e.currentTarget
    element.dataset.selected = !element.dataset.selected

    this.stencilTargets.forEach((element) => {
      if (element.dataset.id === this.projectIdValue) {
        element.classList.add(this.activeClass)
      } else {
        element.classList.remove(this.activeClass)
      }
    })

    if (element.dataset.selected) {
      element.classList.add(this.activeClass)
    } else {
      element.classList.remove(this.activeClass)
    }
  }
}