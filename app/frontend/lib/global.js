$(function () {
  $.onmount()
})
function ShowLoader() {
  $("#pageLoading").fadeIn()
}
function HideLoader() {
  $("#pageLoading").fadeOut()
}
$.onmount("[data-js-single-submit-form]", function () {
  $(this).on("submit", function () {
    $(this).find(":submit").prop("disabled", true)
  })
})
