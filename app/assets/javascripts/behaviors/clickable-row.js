$.onmount('[data-clickable-row]', function () {
  $(this).on('click', function () {
    var row_href;
    row_href = $(this).attr('data-href');
    if (row_href) {
      return document.location = $(this).attr('data-href');
    }
  });
});