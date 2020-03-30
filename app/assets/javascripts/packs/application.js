/* eslint no-console:0 */

import Vue from 'vue/dist/vue.esm'
import SeatCreator from '../components/seat-creator.vue'
import SeatPicker from '../components/seat-picker.vue'

import 'bootstrap/dist/js/bootstrap.bundle.min'
import '@fortawesome/fontawesome-pro/js/all'

import '../clickable-row'
import '../gallery'
import '../giftcard-selection'
import '../global'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#apollo-app',
    components: {
      SeatPicker
    }
  })
})