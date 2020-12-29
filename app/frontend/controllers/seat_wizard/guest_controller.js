import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static values = { guestType: String, forReservation: Boolean }
  static targets = ["emailAddress", "firstName", "guestInfo", "guestInfoAlert", "guestType", "purchaseModeArea",
    "purchaseMode", "lastName", "nextButton", "seatRequest", "seatRequestArea", "seatRequestLabel"]

  connect() {
    if (this.hasPurchaseModeAreaTarget) { this.purchaseModeTarget.hidden = true }
    this.seatRequestAreaTarget.hidden = true
    this.guestInfoTarget.hidden = true
    this.emailAddressTarget.disabled = true
    this.guestInfoAlertTarget.hidden = true
    this.nextButtonTarget.classList.add('disabled')
  }

  toggleGuestType(e) {
    this.guestTypeValue = e.currentTarget.value

    if (this.guestTypeValue === 'self') {
      this.purchaseModeValue = 'now'
    } else if (this.forReservationValue) {
      if (this.hasPurchaseModeAreaTarget) { this.purchaseModeTarget.checked = false }
      this.purchaseModeValue = 'later'
    }
  }

  togglePurchaseMode(e) {
    this.purchaseModeValue = e.currentTarget.checked ? 'now' : 'later'
    this.updateUI() // always trigger
  }

  toggleSeatRequest(e) {
    this.seatRequestAreaTarget.hidden = !e.currentTarget.checked
    this.seatRequestTarget.required = !this.seatRequestAreaTarget.hidden
  }

  // private

  purchaseModeValueChanged() {
    this.updateUI()
  }

  guestTypeValueChanged() {
    this.updateUI()
  }

  updateUI() {
    this.showHideEmailAddress()
    this.showHideGuestInfo()
    if (this.hasPurchaseModeAreaTarget) { this.showHidePurchaseMode() }
    this.notifyWizard()
  }

  notifyWizard() {
    if (!this.isComplete()) {
      this.nextButtonTarget.classList.add('disabled')
      document.dispatchEvent(new CustomEvent('SeatWizard:reset'))
    } else {
      if (this.purchaseModeValue === 'now') {
        this.nextButtonTarget.dataset.destination = 'project'
      } else {
        this.nextButtonTarget.dataset.destination = 'review'
      }

      this.nextButtonTarget.classList.remove('disabled')
    }

    document.dispatchEvent(new CustomEvent('SeatWizard:updateGuestType', {
      detail: {
        guestType: this.guestTypeValue,
        purchaseMode: this.purchaseModeValue,
        valid: this.isComplete()
      }
    }))
  }

  isComplete() {
    if (this.guestTypeValue !== 'self' && this.firstNameTarget.value === '') {
      return false
    }

    if (this.guestTypeValue !== 'self' && this.lastNameTarget.value === '') {
      return false
    }

    if (this.guestTypeValue === 'adult' && this.emailAddressTarget.value === '') {
      return false
    }

    return true
  }

  showHideEmailAddress() {
    if (this.guestTypeValue === 'child' || this.guestTypeValue === 'other' || this.guestTypeValue === 'self') {
      this.emailAddressTarget.disabled = true
      this.emailAddressTarget.required = false
      this.emailAddressTarget.value = ''
    } else {
      this.emailAddressTarget.required = true
      this.emailAddressTarget.disabled = false
    }
  }

  showHidePurchaseMode() {
    if (this.guestTypeValue === 'self') {
      this.purchaseModeTarget.hidden = true
    } else {
      this.purchaseModeTarget.hidden = false
    }
  }

  showHideGuestInfo() {
    if (this.guestTypeValue === 'self') {
      this.guestInfoTarget.hidden = true
      this.firstNameTarget.required = false
      this.lastNameTarget.required = false
      this.seatRequestLabelTarget.innerHTML = "Would you like to sit next to someone specific?"
      this.guestInfoAlertTarget.hidden = true
    } else {
      this.guestInfoTarget.hidden = false
      this.firstNameTarget.required = true
      this.lastNameTarget.required = true
      this.seatRequestLabelTarget.innerHTML = "Would your guest like to sit next to someone specific?"

      if (this.guestTypeValue === 'other' || this.guestTypeValue === 'child') {
        this.guestInfoAlertTarget.hidden = false
        this.guestInfoAlertTarget.innerHTML = "This seat will be linked to your Sign Junkie Workshop account but under your guests name."
      } else if (this.guestTypeValue === 'adult') {
        this.guestInfoAlertTarget.hidden = false
        this.guestInfoAlertTarget.innerHTML = "Enter the name and email of your guest below. After payment, you'll receive a copy of the receipt and we'll send them an invite if they don't have a Sign Junkie Workshop account."
      }
    }
  }
}
