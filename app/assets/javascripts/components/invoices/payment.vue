<script>
import BT from 'braintree-web';

export default {
  name: 'Payment',
  props: {
    token: {
      type: String,
      required: true,
    },
    amount: {
      type: String,
      required: true
    }
  },
  mounted() {
    var form = document.getElementById("new_invoice");
    BT.setup(this.token, "dropin", {
      container: "braintree-container",
      paypal: {
        flow: "checkout",
        amount: this.amount,
        currency: "USD"
      }
    }, function(err, dropinInstance) {
      if (err) {
        Raven.captureException(err);
        return;
      }
      form.addEventListener("submit", function(event) {
        debugger;
        event.preventDefault();
        dropinInstance.requestPaymentMethod(function(err, payload) {
          if (err) {
            dropinInstance.clearSelectedPaymentMethod();
            Raven.captureException(err);
            return;
          }

          this.$emit('update-nonce', payload.nonce)
          form.submit();
        });
      });
    });
  }
}
</script>

<template>
<div id="braintree-container">

</div>
</template>
