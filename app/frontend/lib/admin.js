//
//= rails-ujs
//= jquery/dist/jquery.min
//= onmount/index.js
//= bootstrap/dist/js/bootstrap.bundle.min
//= moment/moment.js
//= tempusdominus-bootstrap-4/build/js/tempusdominus-bootstrap-4.min
//= select2/dist/js/select2.js
//= behaviors/workshop-edit
//= jquery.easing/jquery.easing.min
//= bs-custom-file-input/dist/bs-custom-file-input.min
//= user-preferences
//= global

$(function () {
  $('.toast').toast('show')
  $.fn.datetimepicker.Constructor.Default = $.extend(
    {},
    $.fn.datetimepicker.Constructor.Default,
    {
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
  )
  $("[data-date-time-picker]").datetimepicker({ format: "MM/DD/YYYY hh:mm A" })
  $("[data-future-date-time-picker]").datetimepicker({
    format: "MM/DD/YYYY hh:mm A",
    minDate: moment(new Date())
  })
  $("[data-date-picker]").datetimepicker({ format: "MM-DD-YYYY" })
  $("[data-future-date-picker]").datetimepicker({
    format: "MM-DD-YYYY",
    minDate: moment(new Date())
  })
  if ($('[data-js-multi-select2]').length > 0) {
    $('[data-js-multi-select2]').select2()
  }
})
