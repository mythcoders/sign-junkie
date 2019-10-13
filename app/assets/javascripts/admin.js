//
//= require rails-ujs
//= require jquery/dist/jquery.min
//= require onmount
//= require popper.js/dist/umd/popper.min
//= require bootstrap/dist/js/bootstrap.min
//= require moment/moment.js
//= require tempusdominus-bootstrap-4/build/js/tempusdominus-bootstrap-4.min
//= require select2/dist/js/select2.js
//= require wice_grid
//= require behaviors/clickable-row
//= require behaviors/workshop-edit
//= require jquery.easing.min
//= require bs-custom-file-input.min
//= require peek
//= require peek/views/performance_bar
//= require user-preferences
//= require global

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
  );
  $("[data-date-time-picker]").datetimepicker({ format: "MM/DD/YYYY hh:mm A" });
  $("[data-future-date-time-picker]").datetimepicker({
    format: "MM/DD/YYYY hh:mm A",
    minDate: moment(new Date())
  });
  $("[data-date-picker]").datetimepicker({ format: "MM-DD-YYYY" });
  $("[data-future-date-picker]").datetimepicker({
    format: "MM-DD-YYYY",
    minDate: moment(new Date())
  });
  if ($('[data-js-multi-select2]').length > 0) {
    $('[data-js-multi-select2]').select2();
  }
});