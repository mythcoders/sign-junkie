onmount("[data-js-amount-change]", function() {
  $(this).on("click", function() {
    document.getElementById('cart_amount').value = $(this).html().replace('$', '');
  })
});