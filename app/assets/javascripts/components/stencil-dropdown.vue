<script>
const utils = require('utils.js')

export default {
  name: 'StencilDropdown',
  props: {
    stencils: {
      required: true
    }
  },
  data: function() {
    return {
      stencil: {},
      personalization: ''
    }
  },
  methods: {
    allowStencilPersonalization: function() {
      if (utils.isObjectEmpty(this.stencil)) return false;

      return this.stencil.personilization_allowed;
    }
  },
  watch: {
    stencil: function(value) {
      this.$emit('update-stencil', value)
    },
    personalization: function(value) {
      this.$emit('update-personalization', value)
    }
  }
}
</script>

<template>
<div>
  <div class="form-row">
    <div class="form-group col">
      <i class="fas fa-swatchbook text-primary fa-fw"></i>
      <label for="stencil">Stencil design</label>
      <div class="input-group">
        <select class="form-control custom-select" id="stencil" v-model="stencil">
          <option v-if="stencils && stencils.length == 0" :value='{}'>No stencils for project</option>
          <option :value='{}'>- Please select a stencil -</option>
          <optgroup v-for="category in stencils" :label="category.category_name">
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
      <input class="form-control" autocomplete="false" type="text" id="stencilPersonalization"
             v-model="personalization">
      <p class="form-text text-muted">
        Please enter your information for personalization shown on the design you have chosen, this includes
        any names, dates, city, state, gps coordinates, etc.
      </p>
    </div>
  </div>
</div>
</template>
