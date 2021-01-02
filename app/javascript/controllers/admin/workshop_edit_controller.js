import AdminController from "./admin_controller"

export default class extends AdminController {
  static targets = ["singleSeatAllow", "reservationAllow", "reservationCancelMinimum", "reservationsEnd",
    "reservationAllowMultiple", "totalSeats", "reservationPrice", "reservationMinimum", "reservationMaximum"]

  toggleType(e) {
    this.reservationAllowMultipleTarget.innerHTML = e.currentTarget.dataset.reservationAllowMultiple
    this.reservationAllowTarget.innerHTML = e.currentTarget.dataset.reservationAllow
    this.reservationCancelMinimumTarget.innerHTML = e.currentTarget.dataset.reservationCancelMinimum
    this.reservationMaximumTarget.innerHTML = e.currentTarget.dataset.reservationMaximum
    this.reservationMinimumTarget.innerHTML = e.currentTarget.dataset.reservationMinimum
    this.reservationPriceTarget.innerHTML = e.currentTarget.dataset.reservationPrice
    this.reservationsEndTarget.innerHTML = e.currentTarget.dataset.reservationsEnd
    this.singleSeatAllowTarget.innerHTML = e.currentTarget.dataset.singleSeatAllow
    this.totalSeatsTarget.innerHTML = e.currentTarget.dataset.totalSeats
  }
}