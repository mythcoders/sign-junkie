import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["selectedAmount"]

  setAmount(event) {
    this.selectedAmountTarget.value = event.target.dataset.amount
  }
}