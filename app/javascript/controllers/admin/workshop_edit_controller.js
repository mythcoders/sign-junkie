import AdminController from "./admin_controller"

export default class extends AdminController {
  static targets = ["singleSeatAllow", "reservationAllow", "reservationCancelMinimum", "reservationsEnd",
    "reservationAllowMultiple", "totalSeats", "reservationPrice", "reservationMinimum", "reservationMaximum"]

  toggleType(e) {
    this.singleSeatAllowTarget.innerHTML = e.currentTarget.dataset.singleSeatAllow
    this.reservationAllowTarget.innerHTML = e.currentTarget.dataset.reservationAllow
    this.reservationCancelMinimumTarget.innerHTML = e.currentTarget.dataset.reservationCancelMinimum
    this.reservationsEndTarget.innerHTML = e.currentTarget.dataset.reservationsEnd
    this.reservationAllowMultipleTarget.innerHTML = e.currentTarget.dataset.reservationAllowMultiple
    this.totalSeatsTarget.innerHTML = e.currentTarget.dataset.totalSeats
    this.reservationPriceTarget.innerHTML = e.currentTarget.dataset.reservationPrice
    this.reservationMinimumTarget.innerHTML = e.currentTarget.dataset.reservationMinimum
    this.reservationMaximumTarget.innerHTML = e.currentTarget.dataset.reservationMaximum
  }
}