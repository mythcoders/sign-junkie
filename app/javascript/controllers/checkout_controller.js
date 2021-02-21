import ApplicationController from "./application_controller"
import * as Sentry from "@sentry/browser"

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
        Sentry.captureException(error)
        return
      }

      this.element.addEventListener("submit", function (event) {
        event.preventDefault()
        dropinInstance.requestPaymentMethod(function (paymentError, payload) {
          if (paymentError) {
            dropinInstance.clearSelectedPaymentMethod()
            Sentry.captureException(paymentError)
            return
          }

          this.paymentNonceTarget.value = payload.nonce
          this.element.submit()
        }.bind(this))
      }.bind(this))
    }.bind(this))
  }
}
