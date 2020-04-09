<script>
import axios from 'axios/dist/axios.min'
import AddonDropdown from '../components/seats/addon-dropdown.vue'
import Agreements from '../components/seats/agreements.vue'
import GuestInfo from '../components/seats/guest-info.vue'
import ProjectDropdown from '../components/seats/project-dropdown.vue'
import StencilDropdown from '../components/seats/stencil-dropdown.vue'
const utils = require('lib/utils/utils.js')

export default {
  name: 'SeatPicker',
  components: {
    'addon-dropdown': AddonDropdown,
    'agreements': Agreements,
    'project-dropdown': ProjectDropdown,
    'guest-info': GuestInfo,
    'stencil-dropdown': StencilDropdown
  },
  props: {
    workshopId: {
      required: true,
    },
    seatId: {
      required: false,
    }
  },
  data: function() {
    return {
      errors: [],
      allAgreementsChecked: false,
      workshop: {},
      project: {},
      stencil: {},
      addon: {},
      guestType: 'self',
      firstName: '',
      lastName: '',
      email: '',
      personalizedStencil: '',
      seatingPreference: ''
    }
  },
  beforeCreate() {
    axios.get('/workshops/' + this.$options.propsData.workshopId, {
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => {
        this.workshop = response.data
      })
  },
  computed: {
    price: function() {
      if (utils.isObjectEmpty(this.project)) return null;

      var amount = parseFloat(this.project.price);
      if (!utils.isObjectEmpty(this.addon)) amount += parseFloat(this.addon.price);
      return amount.toFixed(2);
    }
  },
  methods: {
    isObjectEmpty: function(obj) {
      return utils.isObjectEmpty(obj);
    },
    validateForm: function(e) {
      this.errors = [];

      if (this.guestType != 'self') {
        if (this.firstName === '' || this.lastName === '') {
          this.errors.push('You forgot to tell us the name of your guest.')
        }

        if (this.guestType === 'adult' && this.email === '') {
          this.errors.push('We need the email address for your guest.')
        }
      }

      if (utils.isObjectEmpty(this.project)) {
        this.errors.push('You forgot to pick a project.')
      } else if (utils.isObjectEmpty(this.stencil) && !this.project.stencil_optional) {
        this.errors.push('You need to pick more stencils for your project.')
      }

      if (!this.allAgreementsChecked) {
        this.errors.push('All terms and conditions have not been accepted.')
      }

      // this.errors.push('Cart feature is currently disabled.')

      if (this.errors.length) {
        e.preventDefault();
        return false;
      }

      axios.post('/api/cart', {
          type: 'seat',
          authenticity_token: document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
          workshop_id: this.workshop.id,
          project_id: this.project.id,
          stencil_id: utils.isObjectEmpty(this.stencil) ? 0 : this.stencil.id,
          stencil: this.personalizedStencil,
          seating: this.seatingPreference,
          addon_id: utils.isObjectEmpty(this.addon) ? 0 : this.addon.id,
          guest_type: this.guestType,
          gift_seat: false, //should this be true when guestType != 'self'
          first_name: this.firstName,
          last_name: this.lastName,
          email: this.email
        })
        .then(function(response) {
          debugger;
          if (response.status === 200) {
            document.location = response.data.redirect_url
          } else {
            this.errors.push(response.data.errors)
          }
        })
        .catch(function(error) {
          this.errors.push('Your purchase could not be completed at this time. Please try again.')
        });
    }
  }
}
</script>

<template>
<div>
  <div v-show="this.isObjectEmpty(this.workshop)">
    <div class="d-flex justify-content-center">
      <div class="spinner-border" role="status">
        <span class="sr-only">Loading...</span>
      </div>
    </div>
  </div>

  <div v-show="!this.isObjectEmpty(this.workshop)">
    <form @submit="validateForm">
      <p class="card-text">
        <i class="fas fa-calendar-exclamation text-primary fa-fw"></i>
        Seats must be purchased by {{ workshop.purchase_end_date }}
      </p>
      <p class="card-text">
        <i class="fas fa-usd-circle text-primary fa-fw"></i>
        <span v-show="price === null">Select a project to see pricing</span>
        <span v-show="price != null">${{ price }}</span>
      </p>

      <hr>

      <guest-info :seatsForChildren="workshop.family_friendly" v-on:update-guestType="guestType = $event"
                  v-on:update-firstName="firstName = $event" v-on:update-lastName="lastName = $event"
                  v-on:update-email="email = $event" v-on:update-seatingPreference="seatingPreference = $event" />

      <hr class="mt-0">

      <project-dropdown :projects="workshop.projects" :guestType="guestType" v-on:update-project="project = $event" />

      <stencil-dropdown v-show="!isObjectEmpty(this.project)" :stencils="project.stencils" :projectId="project.id"
                        :showPlainOption="project.stencil_optional" v-on:update-stencil="stencil = $event"
                        v-on:update-personalization="personalizedStencil = $event" />

      <addon-dropdown v-show="!isObjectEmpty(this.project)" :addons="project.addons"
                      v-on:update-addon="addon = $event" />

      <hr class="mt-0">

      <agreements :workshop="workshop" v-on:update-agreements="allAgreementsChecked = $event" />

      <div v-if="errors.length" class="alert alert-danger">
        Please correct the following error(s):
        <ul>
          <li v-for="error in errors">{{ error }}</li>
        </ul>
      </div>

      <button class="btn btn-info btn-block" type="submit">
        <i class="fas fa-cart-plus "></i>
        Add to Cart
      </button>
    </form>
  </div>
</div>
</template>
