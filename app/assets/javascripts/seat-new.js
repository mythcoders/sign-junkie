document.addEventListener('DOMContentLoaded', () => {
  $("[data-js-guest-type]").on("change", function(event) {
    if (event.target.value == 'adult') {
      $("#guest-info-title")[0].innerHTML = 'Guest Information'
      $("#child-info-title")[0].innerHTML = 'Guest Information'
      $("[data-js-guest-info]").show();
      $("[data-js-child-info]").hide();
      $("[data-js-child-warning]").hide();
    } else if (event.target.value == 'guest') {
      $("#guest-info-title")[0].innerHTML = 'Guest Information'
      $("#child-info-title")[0].innerHTML = 'Guest Information'
      $("[data-js-guest-info]").hide();
      $("[data-js-child-info]").show();
      $("[data-js-child-warning]").hide();
    } else {
      $("#guest-info-title")[0].innerHTML = 'Parent Information'
      $("#child-info-title")[0].innerHTML = 'Child Information'
      $("[data-js-guest-info]").show();
      $("[data-js-child-info]").show();
      $("[data-js-child-warning]").show();
    }
    $("#seat_first_name").attr("required", event.target.value != 'guest');
    $("#seat_last_name").attr("required", event.target.value != 'guest');
    $("#seat_email").attr("required", event.target.value != 'guest');
    $("#seat_child_first_name").attr("required", event.target.value != 'adult');
    $("#seat_child_last_name").attr("required", event.target.value != 'adult');
  })
})