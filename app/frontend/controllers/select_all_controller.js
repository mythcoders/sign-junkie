import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static targets = ["item", "label"]

  toggle(e) {
    this.labelTarget.innerHTML = e.currentTarget.checked ? 'Unselect all' : 'Select all'

    this.itemTargets.forEach(item => {
      item.checked = e.currentTarget.checked
    })
  }
}