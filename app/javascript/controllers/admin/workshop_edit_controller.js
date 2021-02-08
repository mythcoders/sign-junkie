import AdminController from "./admin_controller"

export default class extends AdminController {
  static targets = ["singleSeatAllow", "reservationAllow", "reservationCancelMinimum", "reservationsEnd", "input",
    "reservationAllowMultiple", "totalSeats", "reservationPrice", "reservationMinimum", "reservationMaximum",
    "reservationAllowGuestCancelSeat"]

  connect() {
    let element = this.inputTargets.find(p => p.checked)
    if (element != null) {
      this.updateUI(element)
    }
  }

  toggleType(e) {
    this.updateUI(e.currentTarget)
  }

  updateUI(element) {
    this.reservationAllowMultipleTarget.innerHTML = element.dataset.reservationAllowMultiple
    this.reservationAllowTarget.innerHTML = element.dataset.reservationAllow
    this.reservationCancelMinimumTarget.innerHTML = element.dataset.reservationCancelMinimum
    this.reservationAllowGuestCancelSeatTarget.innerHTML = element.dataset.reservationAllowGuestCancelSeat
    this.reservationMaximumTarget.innerHTML = element.dataset.reservationMaximum
    this.reservationMinimumTarget.innerHTML = element.dataset.reservationMinimum
    this.reservationPriceTarget.innerHTML = element.dataset.reservationPrice
    this.reservationsEndTarget.innerHTML = element.dataset.reservationsEnd
    this.singleSeatAllowTarget.innerHTML = element.dataset.singleSeatAllow
    this.totalSeatsTarget.innerHTML = element.dataset.totalSeats
  }
}