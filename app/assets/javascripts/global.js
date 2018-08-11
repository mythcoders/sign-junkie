$(function () {
  $('').click(function () {
    var row_href = $(this).attr('data-href');
    if (row_href) {
      document.location = $(this).attr('data-href');
    }
  });
});
function ShowLoader() {
  $("#pageLoading").fadeIn()
}
function HideLoader() {
  $("#pageLoading").fadeOut()
}