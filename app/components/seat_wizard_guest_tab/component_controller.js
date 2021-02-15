import ApplicationController from "../../javascript/controllers/application_controller"

export default class extends ApplicationController {
  static values = {
    forReservation: Boolean,
    guestType: String,
    isParent: Boolean,
    purchaseMode: String,
    previousNotify: Object
  }
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
    "isParent",
    "nextButton",
    "purchaseMode",
    "purchaseModeArea",
    "seatRequest",
    "seatRequestArea",
    "seatRequestLabel",
    "seatRequestToggle"
  ]

  connect() {
    if (this.hasPurchaseModeAreaTarget) { this.purchaseModeTarget.hidden = true }
    if (this.hasGuestInfoTarget) {
      this.emailAddressTarget.disabled = true
      this.guestInfoAlertTarget.hidden = true
      this.guestInfoTarget.hidden = true
    }
    this.seatRequestAreaTarget.hidden = !this.seatRequestToggleTarget.checked
    this.seatRequestTarget.required = !this.seatRequestAreaTarget.hidden
    this.previousNotifyValue = {
      guestType: this.guestTypeValue,
      purchaseMode: this.purchaseModeValue,
      valid: false
    }

    if (this.isValid) {
      this.updateUI()
      this.notifyWizard()
    }
  }

  toggleGuestType(e) {
    this.guestTypeValue = e.currentTarget.value

    if (this.forReservationValue && (this.guestTypeValue === 'adult' || this.guestTypeValue === 'child')) {
      this.purchaseModeValue = 'later'
    } else {
      this.purchaseModeValue = 'now'
    }

    if (this.forReservationValue && this.hasPurchaseModeAreaTarget) { this.purchaseModeTarget.checked = false }

    this.updateUI() // always trigger
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

  updateGuestName(e) {
    this.updateUI() // always trigger
    this.notifyWizard()
  }

  get isValid() {
    if (this.guestTypeValue === '') {
      return false
    }

    if (this.hasChildInfoTarget && this.guestTypeValue === 'child') {
      if (this.childFirstNameTarget.value === '' || this.childLastNameTarget.value === '') {
        return false
      }
    }

    if (this.hasGuestInfoTarget) {
      let isNotKidsParent = this.guestTypeValue === 'child' && !this.isParentValue
      let guestInfoRequired = this.guestTypeValue === 'adult' || this.guestTypeValue === 'other' || isNotKidsParent
      let emailRequired = this.guestTypeValue === 'adult' || isNotKidsParent

      if (emailRequired && this.emailAddressTarget.value === '') {
        return false
      }

      if (guestInfoRequired && (this.guestFirstNameTarget.value === '' || this.guestLastNameTarget.value === '')) {
        return false
      }
    }

    return true
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
    if (this.purchaseModeValue === 'now') {
      this.nextButtonTarget.dataset.destination = 'project'
    } else {
      this.nextButtonTarget.dataset.destination = 'review'
    }

    if (this.isValid) {
      this.nextButtonTarget.classList.remove('disabled')
    } else {
      this.nextButtonTarget.classList.add('disabled')
    }

    if (this.hasGuestInfoTarget) {
      this.showHideEmailAddress()
      this.showHideGuestInfo()
    }
    if (this.hasChildInfoTarget) { this.showHideChildInfo() }
    if (this.hasPurchaseModeAreaTarget) { this.showHidePurchaseMode() }
  }

  notifyWizard() {
    let valid = this.isValid
    let shouldNotifyWizard = valid && !this.previousNotifyValue.valid ||
      this.guestTypeValue != this.previousNotifyValue.guestType ||
      this.purchaseModeValue != this.previousNotifyValue.purchaseMode

    if (valid && shouldNotifyWizard) {
      document.dispatchEvent(new CustomEvent('SeatWizard:updateGuestType', {
        detail: {
          guestType: this.guestTypeValue,
          purchaseMode: this.purchaseModeValue,
          valid: valid
        }
      }))
    } else if (!valid && this.previousNotifyValue.valid) {
      document.dispatchEvent(new CustomEvent('SeatWizard:reset'))
    }

    this.previousNotifyValue = {
      guestType: this.guestTypeValue,
      purchaseMode: this.purchaseModeValue,
      valid: valid
    }
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
    if (this.guestTypeValue === 'self' || this.forReservationValue && this.guestTypeValue === 'other') {
      this.purchaseModeAreaTarget.hidden = true
    } else {
      this.purchaseModeAreaTarget.hidden = false
    }
  }

  showHideGuestInfo() {
    this.seatRequestLabelTarget.innerHTML = this.guestTypeValue === 'self' ?
      "I would like to sit next to someone specific" :
      "My guest would like to sit next to someone specific"

    if (this.guestTypeValue === 'self' || (this.guestTypeValue === 'child' && this.isParentValue)) {
      this.guestFirstNameTarget.required = false
      this.guestFirstNameTarget.value = ''
      this.guestLastNameTarget.required = false
      this.guestLastNameTarget.value = ''
      this.guestInfoTarget.hidden = true
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
