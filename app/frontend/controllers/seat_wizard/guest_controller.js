import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = [
    "emailAddress",
    "guestInfo",
    "guestType",
    "seatRequestArea",
    "seatRequestLabel",
  ]

  connect() {
    this.seatRequestAreaTarget.hidden = true
    this.guestInfoTarget.hidden = true
    this.emailAddressTarget.disabled = true
  }

  toggleType(e) {
    let guestType = e.currentTarget.value

    if (guestType === 'child' || guestType === 'other') {
      this.emailAddressTarget.disabled = true
      this.emailAddressTarget.value = ''
    } else {
      this.emailAddressTarget.disabled = false
    }

    if (guestType === 'self') {
      this.guestInfoTarget.hidden = true
      this.seatRequestLabelTarget.innerHTML = "Would you like to sit next to someone specific?"
    } else {
      this.guestInfoTarget.hidden = false
      this.seatRequestLabelTarget.innerHTML = "Would your guest like to sit next to someone specific?"
    }

    if (!this.isGuestInfoComplete(e)) {
      e.stopImmediatePropagation()
      return
    }
  }

  toggleSeatRequest(e) {
    this.seatRequestAreaTarget.hidden = !e.currentTarget.checked
  }

  // private
  isGuestInfoComplete(e) {
    return false
  }
}