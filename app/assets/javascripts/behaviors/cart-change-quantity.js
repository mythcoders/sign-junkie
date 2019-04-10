$.onmount("[data-js-cart-quantity]", function() {
  $(this).on("change", function() {
    var cart_id, new_price, price, qty, total;
    qty = $(this).val();
    cart_id = $(this).data("cartId");
    price = $(this).data("price");
    new_price = qty * price;
    $("#amt-" + cart_id).html("$" + new_price.toFixed(2));
    total = 0;
    $("[id^=amt-]").each(function(i, v) {
      total += Number(
        $(this)
          .text()
          .replace("$", "")
      );
    });
    $("#total-amt").text("$" + total.toFixed(2));
    $("#checkout-button").hide()
    $("#checkout-loading").show()
    return $("#edit_cart_" + cart_id).submit();
  });
});
