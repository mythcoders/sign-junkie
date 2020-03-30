<script>
export default {
  name: 'SeatCreator',
  props: {
    workshopId: {
      required: true,
    }
  },
  data: function() {
    return {
      guestType: 'self'
    }
  },
  // created: function() {
  //   console.log("I'm open")
  // },
  computed: {
    workshop: function() {
      if (this.workshopId == 0) return {};

      return 'dave'
    }
  },
  methods: {
    recipientVisible: function() {
      return this.workshopId != 'self';
    }
  },
  // function runs whenever property changes
  watch: {}
}
</script>

<template>
<div>
  <p>Hello!</p>
</div>
</template>
