import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item", "label"]

  toggle(e) {
    this.labelTarget.innerHTML = e.currentTarget.checked ? 'Unselect all' : 'Select all'

    this.itemTargets.forEach(item => {
      item.checked = e.currentTarget.checked
    })
  }
}