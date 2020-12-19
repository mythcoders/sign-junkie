import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = [
    "emailAddress",
    "guestInfo",
    "guestInfoAlert",
    "guestType",
    "seatRequestArea",
    "seatRequestLabel",
  ]

  connect() {
    this.seatRequestAreaTarget.hidden = true
    this.guestInfoTarget.hidden = true
    this.emailAddressTarget.disabled = true
    this.guestInfoAlertTarget.hidden = true
  }

  toggleType(e) {
    let guestType = e.currentTarget.value

    this.showHideEmailAddress(guestType)
    this.showHideGuestInfo(guestType)

    if (!this.isGuestInfoComplete(e)) {
      e.stopImmediatePropagation()
      return
    }

    document.dispatchEvent(new Event('seat_wizard.finish_step', { step: 'guest' }))
  }

  toggleSeatRequest(e) {
    this.seatRequestAreaTarget.hidden = !e.currentTarget.checked
  }

  // private

  isGuestInfoComplete(e) {
    return true
  }

  showHideEmailAddress(guestType) {
    if (guestType === 'child' || guestType === 'other') {
      this.emailAddressTarget.disabled = true
      this.emailAddressTarget.value = ''
    } else {
      this.emailAddressTarget.disabled = false
    }
  }

  showHideGuestInfo(guestType) {
    if (guestType === 'self') {
      this.guestInfoTarget.hidden = true
      this.seatRequestLabelTarget.innerHTML = "Would you like to sit next to someone specific?"
      this.guestInfoAlertTarget.hidden = true
    } else {
      this.guestInfoTarget.hidden = false
      this.seatRequestLabelTarget.innerHTML = "Would your guest like to sit next to someone specific?"

      if (guestType === 'other' || guestType === 'child') {
        this.guestInfoAlertTarget.hidden = false
        this.guestInfoAlertTarget.innerHTML = "This seat will be linked to your Sign Junkie Workshop account but under your guests name."
      } else if (guestType === 'adult') {
        this.guestInfoAlertTarget.hidden = false
        this.guestInfoAlertTarget.innerHTML = "Enter the name and email of your guest below. We'll send them an invite if they don't have a Sign Junkie Workshop account."
      }
    }
  }
}
