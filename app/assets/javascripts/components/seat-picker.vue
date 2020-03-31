<script>
import axios from 'axios/dist/axios.min'
// import utils from 'utils'
const utils = require('utils.js')

export default {
  name: 'SeatPicker',
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
      stencilPersonalization: '',
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
      if (this.projectId === 0) return null;

      return 0.00;
    }
  },
  methods: {
    fetchWorkshop: function() {
      const customJs = new CustomJS();
      return new Promise((resolve, reject) => {
        customJs.getTools()
          .then(res => resolve(res))
          .catch(err => reject(err))
      })
    },
    recipientVisible: function() {
      return this.guestType != 'self';
    },
    allowSeatsForChildren: function() {
      if (this.workshop === null) return false;

      return this.workshop.family_friendly;
    },
    allowStencilPersonalization: function() {
      if (this.stencil === null) return false;

      return this.stencil.personilization_allowed;
    },
    submit: function() {
      return false;
    },
    showLoader: function() {
      return utils.isObjectEmpty(this.workshop);
    }
  },
  watch: {
    project: function(oldId, newId) {
      console.log('workshopId changed')
    }
  }
}
</script>

<template>
<div>
  <div v-show="showLoader()" class="d-flex justify-content-center">
    <div class="spinner-border" role="status">
      <span class="sr-only">Loading...</span>
    </div>
  </div>

  <div v-if="!showLoader()">
    <p class=" card-text">
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

    <div class="form-row">
      <div class="form-group col">
        <i class="fas fa-chair text-primary fa-fw"></i>
        <label>Who is this seat for?</label>
        <div class="custom-control custom-radio">
          <input class='custom-control-input' type="radio" v-model="guestType" id="self" value="self" name="guestType">
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
        <div class="custom-control custom-radio" v-show="allowSeatsForChildren()">
          <input class='custom-control-input' type="radio" v-model="guestType" id="child" value="child" name="guestType">
          <label class="custom-control-label" for="child">A child (ages 8-17)</label>
        </div>
      </div>
    </div>

    <div v-show="recipientVisible()">
      <h6 class="card-title">
        <i class="fas fa-user text-primary fa-fw"></i>
        Recipient Information
      </h6>
      <div class="form-row">
        <div class="form-group col-6">
          <label for="firstName">First name</label>
          <input class="form-control" autocomplete="false" type="text" v-model="firstName" id="firstName" required="required">
        </div>
        <div class="form-group col-6">
          <label for="lastName">Last name</label>
          <input class="form-control" autocomplete="false" type="text" v-model="lastName" id="lastName" required="required">
        </div>
        <div class="form-group col-12">
          <label for="email">Email address</label>
          <input class="form-control" autocomplete="false" type="text" v-model="email" id="email">
          <p class="form-control-plaintext text-muted">
            * Email Optional. Provide one if you'd like an invite sent to this person.
          </p>
        </div>
      </div>
    </div>

    <hr>
    <div class="form-row">
      <div class="form-group col">
        <i class="fas fa-sign text-primary fa-fw"></i>
        <label for="project">Project</label>
        <select class="form-control custom-select" required="required" id="project_id" :disabled="workshop === null" v-model="project">
          <option v-if="workshop === null">- Loading... -</option>
          <option v-else :value='null'>- Please select a project -</option>

          <option v-for="project in workshop.projects" :value="project">
            {{ project.name }}
          </option>
        </select>
      </div>
    </div>

    <div class="form-row" v-show="project != null">
      <div class="form-group col">
        <i class="fas fa-swatchbook text-primary fa-fw"></i>
        <label for="stencil">Stencil design</label>
        <div class="input-group">
          <select class="form-control custom-select" id="stencil" :disabled="project === null" v-model="stencil">
            <option v-if="project.addons.length" :value='null'>No addons for project</option>
            <option :value='null'>- Please select a stencil -</option>
            <optgroup v-for="category in project.stencils" :label="category.category_name">
              <option v-for="stencil in category.stencils" :value="stencil">
                {{ stencil.name }}
              </option>
            </optgroup>
          </select>
          <div class="input-group-append">
            <a class="btn btn-outline-secondary" href="/projects/13" target="_blank">Preview</a>
          </div>
        </div>
      </div>
    </div>

    <div class="form-row" v-show="allowStencilPersonalization()">
      <div class="form-group col">
        <i class="fas fa-palette text-primary fa-fw"></i>
        <label for="stencilPersonalization">Stencil personalization</label>
        <input class="form-control" autocomplete="false" type="text" id="stencilPersonalization" v-model="stencilPersonalization">
        <p class="form-text text-muted">
          Please enter your information for personalization shown on the design you have chosen, this includes
          any names, dates, city, state, gps coordinates, etc.
        </p>
      </div>
    </div>

    <div class="form-row" v-show="project != null">
      <div class="form-group col">
        <i class="fas fa-stamp text-primary fa-fw"></i>
        <label for="addon">Add-on</label>
        <select class="form-control custom-select" id="addon" :disabled="project === null" v-model="addon">
          <option v-if="project.addons.length" :value='null'>No addons for project</option>
          <option :value='null'>- Select an addon -</option>

          <option v-for="addon in project.addons" :value="addon">
            {{ addon.name }}
          </option>
        </select>
      </div>
    </div>

    <div class="form-row">
      <div class="form-group col">
        <i class="fas fa-chair text-primary fa-fw"></i>
        <label for="seatingPreference">Seating preference</label>
        <input class="form-control" autocomplete="false" type="text" id="seatingPreference" v-model="seatingPreference">
      </div>
    </div>

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
  </div>
</div>
</template>
