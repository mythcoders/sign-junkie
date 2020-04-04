<script>
export default {
  name: 'CustomerAgreement',
  props: {
    workshop: {
      required: true
    }
  },
  data: function() {
    return {
      acknowledgment: false,
      designConfirmation: false,
      policyAgreement: false,
    }
  },
  methods: {
    updateAgreements: function() {
      if (this.acknowledgment && this.designConfirmation && this.policyAgreement) {
        this.$emit('update-agreements', true)
      } else {
        this.$emit('update-agreements', false)
      }
    }
  }
}
</script>

<template>
<div>
  <div class="form-row">
    <div class="form-group col">
      <div class="custom-switch custom-control">
        <input class="custom-control-input" type="checkbox" value="1" id="acknowledgment"
               @change="updateAgreements($event)" v-model="acknowledgment">
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
        <input class="custom-control-input" type="checkbox" value="1" id="designConfirmation"
               @change="updateAgreements($event)" v-model="designConfirmation">
        <label class="custom-control-label" for="designConfirmation">Design confirmation</label>
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
        <input class="custom-control-input" type="checkbox" value="1" id="policyAgreement"
               @change="updateAgreements($event)" v-model="policyAgreement">
        <label class="custom-control-label" for="policyAgreement">Policy agreement</label>
      </div>
      <p class="form-control-plaintext">
        I have read and agree to the
        <a :href="workshop.policies_path">{{ workshop.type }} Workshop Policies.</a>
        I understand that because projects at Sign Junkie are hand-made, there is a NO REFUND policy
        in place. If I must cancel my reservation I must find someone to come in my place. If I arrive
        later than 20 minutes after the start time, the reservation fee I am about to pay will be forfeited.
        I also understand that NO unfinsihed projects will be given if I fail to attend this workshop.
      </p>
    </div>
  </div>
</div>
</template>
