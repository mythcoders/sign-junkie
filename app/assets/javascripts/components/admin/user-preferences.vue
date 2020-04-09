<script>
const cookieHelper = require('lib/utils/cookie-helper.js')

export default {
  name: 'UserPreferences',
  data: function() {
    return {
      colorScheme: cookieHelper.get('apollo_ui_theme') || 'light'
    }
  },
  methods: {
    save: function() {
      cookieHelper.set('apollo_ui_theme', this.colorScheme)
      location.reload();
    }
  }
};
</script>

<template>
<div class='modal fade fixed-left' id='modalUserPreferences' aria-hidden="true" role="dialog" tabindex="-1">
  <div class='modal-dialog modal-dialog-vertical' role="document">
    <div class='modal-content'>
      <div class='modal-body'>
        <a class='close' aria-label="Close" data-dismiss="modal">
          <span aria-hidden="true">×</span>
        </a>
        <div class='text-center'>
          <img class='img-fluid mb-3' src="/illustrations/designer-life.svg" alt="Placeholder image">
        </div>
        <h2 class='text-center mb-2'>
          Make Apollo Your Own
        </h2>
        <p class='text-center mb-4'>
          Set preferences that will be saved for you.
        </p>
        <hr class='mb-4'>
        <h4 class='mb-1'>
          Color Scheme
        </h4>
        <p class='small text-muted mb-3'>
          Overall light or dark presentation.
        </p>
        <div class='btn-group-toggle d-flex mb-4'>
          <label class='btn btn-white col' v-bind:class="{ 'active': colorScheme === 'light' }">
            <input class='form-check-input' type="radio" v-model="colorScheme" value="light" name="colorScheme">
            <i class='fad fa-sun mr-2'></i>
            Light Mode
          </label>
          <label class='btn btn-white col ml-2' v-bind:class="{ 'active': colorScheme === 'dark' }">
            <input class='form-check-input' type="radio" v-model="colorScheme" value="dark" name="colorScheme">
            <i class='fad fa-moon mr-2'></i>
            Dark Mode
          </label>
        </div>
      </div>
      <div class='modal-footer border-0'>
        <button class='btn btn-block btn-primary mt-auto' v-on:click='save()'>
          Update Preferences
        </button>
      </div>
    </div>
  </div>
</div>
</template>
