document.addEventListener('DOMContentLoaded', () => {
  $('[data-js-single-submit-form]').on("submit", function() {
    $(this).find(":submit").prop("disabled", true);
  })
  $('[data-clickable-row]').on('click', function() {
    var row_href = $(this).attr('data-href');
    if (row_href) {
      document.location = $(this).attr('data-href');
    }
  })
})