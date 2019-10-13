$(function () {
  $.onmount();
  ui_html = "<div class='d-block d-sm-none'><span><strong>XS</strong> ui</span></div>"
    + "<div class='d-none d-sm-block d-md-none'><span><strong>SM</strong> ui</span></div>"
    + "<div class='d-none d-md-block d-lg-none'><span><strong>MD</strong> ui</span></div>"
    + "<div class='d-none d-lg-block d-xl-none'><span><strong>L</strong> ui</span></div>"
    + "<div class='d-none d-xl-block'><span><strong>XL</strong> ui</span></div>";
  $('#peek .wrapper').append(ui_html);
});
function ShowLoader() {
  $("#pageLoading").fadeIn();
}
function HideLoader() {
  $("#pageLoading").fadeOut();
}
