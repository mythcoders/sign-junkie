import ApplicationController from "../../javascript/controllers/application_controller"

export default class extends ApplicationController {
  static values = { guestType: String, isParent: Boolean, forReservation: Boolean }
  static targets = [
    "childFirstName",
    "childInfo",
    "childLastName",
    "emailAddress",
    "guestFirstName",
    "guestInfo",
    "guestInfoAlert",
    "guestInfoHeader",
    "guestLastName",
    "guestType",
    "isParent",
    "nextButton",
    "purchaseMode",
    "purchaseModeArea",
    "seatRequest",
    "seatRequestArea",
    "seatRequestLabel"
  ]

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
    if (!this.hasIsParentValue) { this.isParentValue = true }

    if (this.guestTypeValue === 'self' || (this.guestTypeValue === 'child' && this.isParentValue)) {
      this.purchaseModeValue = 'now'
    } else if (this.forReservationValue) {
      if (this.hasPurchaseModeAreaTarget) { this.purchaseModeTarget.checked = false }
      this.purchaseModeValue = 'later'
    } else {
      this.purchaseModeValue = 'now'
    }

    this.notifyWizard()
  }

  togglePurchaseMode(e) {
    this.purchaseModeValue = e.currentTarget.checked ? 'now' : 'later'

    this.updateUI() // always trigger
    this.notifyWizard()
  }

  toggleSeatRequest(e) {
    this.seatRequestAreaTarget.hidden = !e.currentTarget.checked
    this.seatRequestTarget.required = !this.seatRequestAreaTarget.hidden
  }

  toggleIsParent(e) {
    this.isParentValue = e.currentTarget.checked
    this.notifyWizard()
  }

  // private

  purchaseModeValueChanged() {
    this.updateUI()
  }

  guestTypeValueChanged() {
    this.updateUI()
  }

  isParentValueChanged() {
    this.updateUI()
  }

  updateUI() {
    this.showHideChildInfo()
    this.showHideEmailAddress()
    this.showHideGuestInfo()
    if (this.hasPurchaseModeAreaTarget) { this.showHidePurchaseMode() }
  }

  notifyWizard() {
    if (!this.isComplete()) {
      this.nextButtonTarget.classList.add('disabled')

      // do we always want to do this?!
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
    let guestInfoRequired = this.guestTypeValue !== 'self' || (this.guestTypeValue === 'child' && !this.isParentValue)
    let emailRequired = this.guestTypeValue === 'adult' || (this.guestTypeValue === 'child' && !this.isParentValue)

    if (this.guestTypeValue === '') {
      return false
    }

    if (emailRequired && this.emailAddressTarget.value === '') {
      return false
    }

    if (guestInfoRequired && (this.guestFirstNameTarget.value === '' || this.guestLastNameTarget.value === '')) {
      return false
    }

    if ((this.guestTypeValue === 'child') && (this.childFirstNameTarget.value === '' || this.childLastNameTarget.value === '')) {
      return false
    }

    return true
  }

  showHideChildInfo() {
    if (this.guestTypeValue === 'child') {
      this.childInfoTarget.hidden = false
      this.childFirstNameTarget.required = true
      this.childLastNameTarget.required = true
    } else {
      this.childInfoTarget.hidden = true
      this.childFirstNameTarget.required = false
      this.childLastNameTarget.required = false
    }
  }

  showHideEmailAddress() {
    if (this.guestTypeValue === 'other' || this.guestTypeValue === 'self' || (this.guestTypeValue === 'child' && this.isParentValue)) {
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
    this.seatRequestLabelTarget.innerHTML = this.guestTypeValue === 'self' ?
      "I would like to sit next to someone specific" :
      "My guest would like to sit next to someone specific"

    if (this.guestTypeValue === 'self' || (this.guestTypeValue === 'child' && this.isParentValue)) {
      this.guestInfoTarget.hidden = true
      this.guestFirstNameTarget.required = false
      this.guestLastNameTarget.required = false
      this.guestInfoAlertTarget.hidden = true
    } else {
      this.guestInfoHeaderTarget.innerHTML = this.guestTypeValue === 'child' ? "Parent Information" : "Guest Information"
      this.guestInfoAlertTarget.hidden = false
      this.guestInfoTarget.hidden = false
      this.guestFirstNameTarget.required = true
      this.guestLastNameTarget.required = true

      if (this.guestTypeValue === 'other') {
        this.guestInfoAlertTarget.innerHTML = "This seat will be linked to your Sign Junkie Workshop account but under your guests name."
      } else if (this.guestTypeValue === 'child') {
        this.guestInfoAlertTarget.innerHTML = "This seat will be for the child listed above. However, we still require the parents information so we can associate the seat to a user account. If the parent does not have an email address then say this is your child."
      } else if (this.guestTypeValue === 'adult') {
        this.guestInfoAlertTarget.innerHTML = "Enter the name and email of your guest below. After payment, you'll receive a copy of the receipt and we'll send them an invite if they don't have a Sign Junkie Workshop account."
      }
    }
  }
}
