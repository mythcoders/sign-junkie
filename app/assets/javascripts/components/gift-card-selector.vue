<script>
export default {
  name: 'GiftCardSelector',
  data: function() {
    return {
      errors: [],
      preFilledAmounts: [25, 30, 40, 50, 75, 100],
      first_name: '',
      last_name: '',
      email: '',
      amount: 25
    }
  },
  computed: {
    csrf: function() {
      return document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    }
  },
  methods: {
    validateForm: function(e) {
      this.errors = [];

      if (this.first_name === '' || this.last_name === '') {
        this.errors.push('You forgot to tell us who the gift card is for.')
      }

      if (this.email === '') {
        this.errors.push('We need an email address to associate with this gift card.')
      }

      if (this.errors.length) {
        e.preventDefault();
      } else {
        return true;
      }
    }
  }
}
</script>

<template>
<div>
  <form method="post" action="/cart" @submit="validateForm">
    <input type="hidden" name="type" value="gift_card">
    <input type="hidden" name="authenticity_token" :value="csrf">

    <div class='card'>
      <h4 class='card-header bg-primary text-white'>
        Gift Card
      </h4>
      <div class='card-body'>
        <p class='card-text'>
          Please enter the information of the person you're giving the gift card to.
          We'll send them an email and invite them to Sign Junkie.
        </p>
        <div class='form-row'>
          <div class='form-group col-md-6'>
            <label for="first_name">First name</label>
            <input class="form-control" autocomplete="false" type="text" v-model="first_name" name="first_name">
          </div>
          <div class='form-group col-md-6'>
            <label for="last_name">First name</label>
            <input class="form-control" autocomplete="false" type="text" v-model="last_name" name="last_name">
          </div>
        </div>
        <div class='form-row'>
          <div class='form-group col'>
            <label for="email">Email address</label>
            <input class="form-control" autocomplete="false" type="text" v-model="email" name="email">
          </div>
        </div>
        <div class='form-row'>
          <div class='form-group col'>
            <label>Gift card amount</label>
            <br />
            <button class='btn btn-primary btn-lg mr-1' type='button' v-on:click="amount = preAmt"
                    v-for="preAmt in preFilledAmounts">${{ preAmt }}</button>
          </div>
        </div>
        <div class='form-row'>
          <div class='form-group col'>
            <div class='input-group'>
              <div class='input-group-prepend'>
                <div class='input-group-text' id='btnGroupAddon'>$</div>
              </div>
              <input class="form-control" autocomplete="false" type="number" v-model="amount" name="amount">
            </div>
          </div>
        </div>
        <div v-if="errors.length" class="alert alert-danger">
          Please correct the following error(s):
          <ul>
            <li v-for="error in errors">{{ error }}</li>
          </ul>
        </div>
      </div>
      <div class='card-footer'>
        <button class='btn btn-info btn-block' type="submit">
          <i class='fas fa-cart-plus'></i>
          <span>Add to Cart</span>
        </button>
      </div>
    </div>
  </form>
</div>
</template>
