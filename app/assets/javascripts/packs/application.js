/* eslint no-console:0 */

import * as Sentry from '@sentry/browser';
import Vue from 'vue/dist/vue.esm'
import SeatCreator from '../components/seat-creator.vue'
import GiftCardSelector from '../components/gift-card-selector.vue'
import SeatPicker from '../components/seat-picker.vue'

import 'bootstrap/dist/js/bootstrap.bundle.min'

import '../clickable-row'
import '../gallery'
import '../global'

document.addEventListener('DOMContentLoaded', () => {
  Sentry.init({
    dsn: 'https://88201b6ab32943ce8864d958fb947d69@sentry.io/1285199'
  });
  const app = new Vue({
    el: '#apollo-app',
    components: {
      GiftCardSelector,
      SeatPicker
    }
  })
})