onmount('[data-js-img-gallery-thumbnail]', function() {
  $(this).on('click', function(e) {
    var photo = $(this).attr('src');
    $('[data-js-img-gallery-preview]').fadeOut(function() {
      $('[data-js-img-gallery-preview]').attr('src', photo).fadeIn();
    });
  });
});