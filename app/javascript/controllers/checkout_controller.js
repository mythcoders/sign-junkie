import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static values = { clientToken: String, purchaseAmount: String }
  static targets = ["paymentNonce"]

  connect() {
    var dropin = require('braintree-web-drop-in')

    dropin.create({
      authorization: this.clientTokenValue,
      container: "#payment-container",
      paypal: {
        flow: "checkout",
        amount: this.purchaseAmountValue,
        currency: "USD"
      },
    }, function (error, dropinInstance) {
      if (error) {
        console.log(error)
        return
      }

      this.element.addEventListener("submit", function (event) {
        event.preventDefault()
        dropinInstance.requestPaymentMethod(function (paymentError, payload) {
          if (paymentError) {
            dropinInstance.clearSelectedPaymentMethod()
            console.log(paymentError)
            return
          }

          this.paymentNonceTarget.value = payload.nonce
          this.element.submit()
        }.bind(this))
      }.bind(this))
    }.bind(this))
  }
}
