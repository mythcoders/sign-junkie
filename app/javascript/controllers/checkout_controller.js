import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static values = { clientToken: String, purchaseAmount: String }

  connect() {
    var form = document.querySelector(".new_invoice")
    var nonceInput = document.querySelector("#payment_method_nonce")

    var dropin = require('braintree-web-drop-in')
    dropin.create({
      authorization: this.clientTokenValue,
      container: "#payment-container",
      paypal: {
        flow: "checkout",
        amount: this.purchaseAmountValue,
        currency: "USD"
      },
    }, function (err, dropinInstance) {
      // HideLoader()
      if (err) {
        console.error(err)
        return
      }
      form.addEventListener("submit", function (event) {
        event.preventDefault()
        dropinInstance.requestPaymentMethod(function (err, payload) {
          if (err) {
            dropinInstance.clearSelectedPaymentMethod()
            console.error(err)
            return
          }
          nonceInput.value = payload.nonce
          form.submit()
        })
      })
    })
  }
}