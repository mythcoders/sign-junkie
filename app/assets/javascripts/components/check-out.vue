<script>
import csrf from 'lib/utils/csrf';
import Payment from 'components/invoices/payment.vue';

export default {
  name: 'CheckOut',
  components: {
    'payment': Payment
  },
  props: {
    paymentToken: {
      type: String,
      required: true,
    },
    paymentAmount: {
      type: String,
      required: true
    },
    createdAt: {
      type: String,
      required: true
    },
    showTestPaymentInfo: {
      default: false,
      required: false
    },
    applyGiftCards: {
      required: false
    }
  },
  data: function() {
    return {
      paymentNonce: ''
    }
  },
  computed: {
    csrf: function() {
      return csrf.token
    }
  }
}
</script>

<template>
<div>
  <form method="post" action="/orders" id="new_invoice">
    <input type="hidden" name="authenticity_token" :value="csrf">
    <input type="hidden" name="created_at" :value="this.createdAt">
    <input type="hidden" name="gift_cards" :value="this.applyGiftCards">
    <input type="hidden" name="payment_method_nonce" :value="this.paymentNonce">

    <div v-if="showTestPaymentInfo" class='alert alert-warning'>
      <strong>Test Credit Card</strong>
      <p>Use the following Credit Card information when checking out with a card</p>
      <samp>4111-1111-1111-1111</samp>
      <br>
      <samp>01/23 100</samp>
    </div>

    <payment :token="this.paymentToken" :amount="this.paymentAmount" v-on:update-nonce="paymentNonce = $event" />

    <button class='btn btn-info btn-block mt-3' type="submit">
      <i class='fas fa-cash-register'></i>
      <span>Place order</span>
    </button>
  </form>
</div>
</template>
