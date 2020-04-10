document.addEventListener('DOMContentLoaded', () => {
  $('[data-js-img-gallery-thumbnail]').on('click', function(e) {
    var photo = $(this).attr('src');
    $('[data-js-img-gallery-preview]').fadeOut(function() {
      $('[data-js-img-gallery-preview]').attr('src', photo).fadeIn();
    });
  })
})