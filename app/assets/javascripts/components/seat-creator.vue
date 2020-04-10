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
  }
}
</script>

<template>
<div>
  <p>Hello!</p>
</div>
</template>
