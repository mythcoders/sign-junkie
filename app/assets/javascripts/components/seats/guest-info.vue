<script>
export default {
  name: 'GuestInfo',
  props: {
    isSelfTypeAllowed: {
      required: false,
      default: true
    },
    isChildTypeAllowed: {
      required: true
    }
  },
  data: function() {
    return {
      guestType: '',
      firstName: '',
      lastName: '',
      email: '',
      hasSeatPreference: false,
      requestedSeat: ''
    }
  },
  methods: {
    guestInformationVisible: function() {
      return this.guestType === 'adult' || this.guestType === 'guest' || this.guestType === 'child';
    }
  },
  watch: {
    guestType: function(value) {
      this.$emit('update-guestType', value)
    },
    firstName: function(value) {
      this.$emit('update-firstName', value)
    },
    lastName: function(value) {
      this.$emit('update-lastName', value)
    },
    email: function(value) {
      this.$emit('update-email', value)
    },
    requestedSeat: function(value) {
      this.$emit('update-seatingPreference', value)
    }
  }
}
</script>

<template>
<div>
  <div class="form-row">
    <div class="form-group col">
      <i class="fas fa-user text-primary fa-fw"></i>
      <label>Who is this seat for?</label>
      <div class="custom-control custom-radio">
        <input class='custom-control-input' type="radio" v-model="guestType" id="self" value="self" name="guestType"
               :disabled="!isSelfTypeAllowed">
        <label class="custom-control-label" for="self">Myself</label>
      </div>
      <div class="custom-control custom-radio">
        <input class='custom-control-input' type="radio" v-model="guestType" id="adult" value="adult" name="guestType">
        <label class="custom-control-label" for="adult">An adult or someone with an email address</label>
      </div>
      <div class="custom-control custom-radio">
        <input class='custom-control-input' type="radio" v-model="guestType" id="guest" value="guest" name="guestType">
        <label class="custom-control-label" for="guest">Someone without an email address</label>
      </div>
      <div class="custom-control custom-radio" v-show="isChildTypeAllowed">
        <input class='custom-control-input' type="radio" v-model="guestType" id="child" value="child" name="guestType">
        <label class="custom-control-label" for="child">A child (ages 8-17)</label>
      </div>
    </div>
  </div>

  <div v-show="guestInformationVisible()">
    <h6 class="card-title">
      <i class="fas fa-user text-primary fa-fw"></i>
      Guest Information
    </h6>
    <div class="form-row">
      <div class="form-group col-6">
        <label for="firstName">First name</label>
        <input class="form-control" autocomplete="false" type="text" v-model="firstName">
      </div>
      <div class="form-group col-6">
        <label for="lastName">Last name</label>
        <input class="form-control" autocomplete="false" type="text" v-model="lastName">
      </div>
      <div class="form-group col-12" v-show="this.guestType === 'adult'">
        <label for="email">Email address</label>
        <input class="form-control" autocomplete="false" type="text" v-model="email">
      </div>
    </div>
  </div>

  <div class="form-row">
    <div class="form-group col">
      <i class="fas fa-chair text-primary fa-fw"></i>
      <label>Seating preference</label>
      <div class="custom-switch custom-control">
        <input class="custom-control-input" type="checkbox" value="1" id="hasSeatPreference"
               v-model="hasSeatPreference">
        <label class="custom-control-label" for="hasSeatPreference" v-show="guestInformationVisible()">
          Would {{ this.firstName || 'this guest' }} like to sit next to someone specific?
        </label>
        <label class="custom-control-label" for="hasSeatPreference" v-show="!guestInformationVisible()">
          Would you like to sit next to someone specific?
        </label>
      </div>
      <div v-show="this.hasSeatPreference">
        <p class="form-control-plaintext text-muted" v-show="this.hasSeatPreference">
          Enter the guests name below. We'll do our best to accomidate your request.
        </p>
        <input class="form-control" autocomplete="false" type="text" v-model="requestedSeat"
               placeholder="First and Last name">
      </div>
    </div>
  </div>
</div>
</template>
