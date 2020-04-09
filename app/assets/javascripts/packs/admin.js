/* eslint no-console:0 */

require.context('../images', true)

import * as Sentry from '@sentry/browser';
import Vue from 'vue/dist/vue.esm'
import UserPreferences from '../components/admin/user-preferences'
import WorkshopGrid from '../components/admin/workshop-grid'

import 'bootstrap/dist/js/bootstrap.bundle.min'
import 'jquery.easing/jquery.easing.min'
import 'tempusdominus-bootstrap-4/build/js/tempusdominus-bootstrap-4.min'
import 'select2/dist/js/select2.js'
import 'bs-custom-file-input/dist/bs-custom-file-input.min'
import '@progress/kendo-theme-bootstrap/dist/all.css'

import '../global'
import '../workshop-edit'

document.addEventListener('DOMContentLoaded', () => {
  Sentry.init({
    dsn: 'https://88201b6ab32943ce8864d958fb947d69@sentry.io/1285199'
  });
  const app = new Vue({
    el: '#apollo-app',
    components: {
      UserPreferences,
      WorkshopGrid
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