<script>
export default {
  name: 'AddonDropdown',
  props: {
    addons: {
      required: true
    }
  },
  data: function() {
    return {
      addon: {}
    }
  },
  watch: {
    addon: function(value) {
      this.$emit('update-addon', value)
    }
  }
}
</script>

<template>
<div v-if="addons && addons.length">
  <div class="form-row">
    <div class="form-group col">
      <i class="fas fa-stamp text-primary fa-fw"></i>
      <label for="addon">Add-on</label>
      <select class="form-control custom-select" id="addon" v-model="addon">
        <option :value='{}'>- Select an optional add-on -</option>
        <option v-for="addon in addons" :value="addon">
          {{ addon.name }}
        </option>
      </select>
    </div>
  </div>
</div>
</template>
