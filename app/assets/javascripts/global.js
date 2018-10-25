$(function() {
  console.log('global loaded');
  window.FontAwesome.dom.i2svg();
  $.onmount();
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
    minDate: moment(new Date()).add(1, "days")
  });
  $("[data-date-picker]").datetimepicker({ format: "MM-DD-YYYY" });
  $("[data-future-date-picker]").datetimepicker({
    format: "MM-DD-YYYY",
    minDate: moment(new Date()).add(1, "days")
  });
});
function ShowLoader() {
  $("#pageLoading").fadeIn();
}
function HideLoader() {
  $("#pageLoading").fadeOut();
}
