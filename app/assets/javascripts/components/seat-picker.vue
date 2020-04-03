<script>
import axios from 'axios/dist/axios.min'
import AddonDropdown from '../components/addon-dropdown.vue'
import ProjectDropdown from '../components/project-dropdown.vue'
import SeatGuestInfo from '../components/seat-guest-info.vue'
import StencilDropdown from '../components/stencil-dropdown.vue'
const utils = require('utils.js')

export default {
  name: 'SeatPicker',
  components: {
    'addon-dropdown': AddonDropdown,
    'project-dropdown': ProjectDropdown,
    'seat-guest-info': SeatGuestInfo,
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
      guestType: 'self',
      firstName: '',
      lastName: '',
      email: '',
      workshop: {},
      project: {},
      stencil: {},
      addon: {},
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

      var amount = parseFloat(this.project.material_price) + parseFloat(this.project.instructional_price);
      if (!utils.isObjectEmpty(this.addon)) amount += parseFloat(this.addon.price);
      return "$" + amount.toFixed(2);
    }
  },
  methods: {
    isObjectEmpty: function(obj) {
      return utils.isObjectEmpty(obj);
    },
    submit: function() {
      return false;

      axios.post('/cart', {
          cart: {
            guestType: this.guestType,
            firstName: this.firstName,
            lastName: this.lastName,
            email: this.email,
            workshop_id: this.workshop.id,
            project_id: utils.isObjectEmpty(this.project) ? 0 : this.project.id,
            stencil_id: utils.isObjectEmpty(this.stencil) ? 0 : this.stencil.id,
            addon_id: utils.isObjectEmpty(this.addon) ? 0 : this.addon.id,
            personalizedStencil: this.personalizedStencil,
            seatingPreference: this.seatingPreference
          }
        })
        .then(function(response) {
          console.log(response);
        })
        .catch(function(error) {
          console.log(error);
        });
    }
  }
}
</script>

<!-- TODO: Figure out submtting form with the blank values of '{}' -->

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
    <form>
      <p class="card-text">
        <i class="fas fa-ticket-alt text-primary fa-fw"></i>
        {{ workshop.remaining_seats }} seats available
      </p>
      <p class="card-text">
        <i class="fas fa-calendar-exclamation text-primary fa-fw"></i>
        Seats must be purchased by {{ workshop.purchase_end_date }}
      </p>
      <p class="card-text">
        <i class="fas fa-usd-circle text-primary fa-fw"></i>
        {{ price || 'Select a project to see pricing' }}
      </p>

      <hr>

      <seat-guest-info :seatsForChildren="workshop.family_friendly" v-on:update-guestType="guestType = $event"
                       v-on:update-firstName="firstName = $event" v-on:update-lastName="lastName = $event"
                       v-on:update-email="email = $event" v-on:update-seatingPreference="seatingPreference = $event" />

      <hr>

      <project-dropdown :projects="workshop.projects" :guestType="guestType" v-on:update-project="project = $event" />

      <stencil-dropdown v-show="!isObjectEmpty(this.project)" :stencils="project.stencils"
                        v-on:update-stencil="stencil = $event"
                        v-on:update-personalization="personalizedStencil = $event" />

      <addon-dropdown v-show="!isObjectEmpty(this.project)" :addons="project.addons"
                      v-on:update-addon="addon = $event" />

      <hr>

      <div class="form-row">
        <div class="form-group col">
          <div class="custom-switch custom-control">
            <input class="custom-control-input" required="required" type="checkbox" value="1" id="acknowledgment">
            <label class="custom-control-label" for="acknowledgment">Acknowledgment</label>
          </div>
          <p class="form-control-plaintext">
            I understand this is a Wood Workshop, so my sign MAY HAVE random cracks, chips, knots, and
            other NATURAL blemishes that give it it’s characteristics.
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group col">
          <div class="custom-switch custom-control">
            <input class="custom-control-input" required="required" type="checkbox" value="1" id="design_confirmation">
            <label class="custom-control-label" for="design_confirmation">Design confirmation</label>
          </div>
          <p class="form-control-plaintext">
            I have entered the correct design and/or customization info. I userstand that NO CHANGES
            can be made to my design choice OR any personalization once my reservation is submitted.
          </p>
        </div>
      </div>

      <div class="form-row">
        <div class="form-group col">
          <div class="custom-switch custom-control">
            <input class="custom-control-input" required="required" type="checkbox" value="1" id="policy_agreement">
            <label class="custom-control-label" for="policy_agreement">Policy agreement</label>
          </div>
          <p class="form-control-plaintext">
            I have read and agree to the
            <a href="/policies">Public Workshop Policies.</a>
            I understand that because projects at Sign Junkie are hand-made, there is a NO REFUND policy
            in place. If I must cancel my reservation I must find someone to come in my place. If I arrive
            later than 20 minutes after the start time, the reservation fee I am about to pay will be forfeited.
            I also understand that NO unfinsihed projects will be given if I fail to attend this workshop.
          </p>
        </div>
      </div>

      <button class="btn btn-info btn-block" v-on:click="submit()">
        <i class="fas fa-cart-plus "></i>
        Add to Cart
      </button>
    </form>
  </div>
</div>
</template>
