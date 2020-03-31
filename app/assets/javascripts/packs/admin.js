/* eslint no-console:0 */

import Vue from 'vue/dist/vue.esm'
import UserPreferences from '../components/user-preferences'

import 'bootstrap/dist/js/bootstrap.bundle.min'
import '@fortawesome/fontawesome-pro/js/all'
import 'jquery.easing/jquery.easing.min'
import 'tempusdominus-bootstrap-4/build/js/tempusdominus-bootstrap-4.min'
import 'select2/dist/js/select2.js'
import 'bs-custom-file-input/dist/bs-custom-file-input.min'
// import wice_grid

import '../global'
import '../clickable-row'
import '../workshop-edit'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#apollo-app',
    components: {
      UserPreferences
    }
  })
  $('.toast').toast('show')
  $.fn.datetimepicker.Constructor.Default = $.extend({},
    $.fn.datetimepicker.Constructor.Default, {
      icons: {
        time: "far fa-clock",
        date: "far fa-calendar",
        up: "far fa-arrow-up",
        down: "far fa-arrow-down",
        previous: "far fa-chevron-left",
        next: "far fa-chevron-right",
        today: "far fa-calendar-check-o",
        clear: "far fa-trash",
        close: "far fa-times"
      }
    }
  );
  $("[data-date-time-picker]").datetimepicker({
    format: "MM/DD/YYYY hh:mm A"
  });
  $("[data-future-date-time-picker]").datetimepicker({
    format: "MM/DD/YYYY hh:mm A",
    minDate: moment(new Date())
  });
  $("[data-date-picker]").datetimepicker({
    format: "MM-DD-YYYY"
  });
  $("[data-future-date-picker]").datetimepicker({
    format: "MM-DD-YYYY",
    minDate: moment(new Date())
  });
})