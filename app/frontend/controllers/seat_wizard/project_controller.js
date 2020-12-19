import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static classes = ["active"]
  static targets = [
    "project"
  ]
  static values = {
    projectId: String,
  }

  toggle(e) {
    this.projectIdValue = e.currentTarget.dataset.id

    this.projectTargets.forEach((element) => {
      if (element.dataset.id === this.projectIdValue) {
        element.classList.add(this.activeClass)
      } else {
        element.classList.remove(this.activeClass)
      }
    })
  }
}