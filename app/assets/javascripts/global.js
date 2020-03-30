onmount("[data-js-single-submit-form]", function() {
  $(this).on("submit", function() {
    $(this).find(":submit").prop("disabled", true);
  })
});