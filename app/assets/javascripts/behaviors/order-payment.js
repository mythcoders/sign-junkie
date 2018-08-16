$.onmount("[data-js-order-pick-up]", function() {
  $(this).on("click", function() {
    var button;
    button = document.querySelector("#submit-button");
    return braintree.dropin.create(
      {
        authorization: "CLIENT_AUTHORIZATION",
        container: "#dropin-container"
      },
      function(createErr, instance) {
        button.addEventListener("click", function() {
          instance.requestPaymentMethod(function(
            requestPaymentMethodErr,
            payload
          ) {});
        });
      }
    );
  });
});
