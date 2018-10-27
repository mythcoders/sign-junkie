$.onmount("[data-js-address]", function() {
  $(this).on("change", function() {
    update_address();
  });
});

$.onmount("[data-js-payment-method]", function() {
  $(this).on("change", function() {
    update_payment_method();
  });
});

$(function() {
  update_address();
  return update_payment_method();
});

function disable_payment_section() {
  $("#order_payment_method_card").attr("disabled", "disabled");
  $("#order_payment_method_paypal").attr("disabled", "disabled");
}

function enable_payment_section() {
  $("#order_payment_method_card").removeAttr("disabled");
  $("#order_payment_method_paypal").removeAttr("disabled");
}

function get_payment_method() {
  return $('input[name="order[payment_method]"]:checked').val();
}

function get_address() {
  return $("[data-js-address]").val() || null;
}

function new_braintree(data) {
  var form, nonceInput, selected_method;
  $("#payment-container").html("");
  $("#payment_method_nonce").val("");
  selected_method = get_payment_method();
  form = document.querySelector(".new_order");
  nonceInput = document.querySelector("#payment_method_nonce");
  braintree.dropin.create(
    {
      authorization: data.client_token,
      container: "#payment-container",
      paymentOptionPriority: [selected_method],
      paypal: {
        flow: "checkout",
        amount: data.total_due_unformatted,
        currency: "USD"
      }
    },
    function(err, dropinInstance) {
      HideLoader();
      if (err) {
        console.error(err);
        return;
      }
      form.addEventListener("submit", function(event) {
        event.preventDefault();
        dropinInstance.requestPaymentMethod(function(err, payload) {
          if (err) {
            dropinInstance.clearSelectedPaymentMethod();
            console.error(err);
            return;
          }
          nonceInput.value = payload.nonce;
          form.submit();
        });
      });
    }
  );
}

function recalc_prices() {
  return $.ajax({
    url: "/orders/ui",
    method: "POST",
    dataType: "json",
    cache: "false",
    data: {
      authenticity_token: $("input[name=authenticity_token]").val(),
      order: {
        payment_method: get_payment_method(),
        address_id: get_address()
      }
    },
    success: function(data, textStatus, jQxhr) {
      update_prices(data);
    },
    error: function(jqXHR, textStatus, errorThrown) {
      HideLoader();
      console.error(jqXHR);
      alert(
        "An error occurred while attempting to fetch prices. Please try again."
      );
    }
  });
}

function update_payment_method() {
  var method = get_payment_method();
  if (method === "paypal" || method === "card") {
    $("#payment-container").show();
    ShowLoader();
    $.ajax({
      url: "/orders/ui",
      method: "POST",
      dataType: "json",
      cache: "false",
      data: {
        authenticity_token: $("input[name=authenticity_token]").val(),
        order: {
          payment_method: get_payment_method(),
          address_id: get_address()
        }
      },
      success: function(data, textStatus, jQxhr) {
        update_prices(data);
        new_braintree(data);
      },
      error: function(jqXHR, textStatus, errorThrown) {
        HideLoader();
        console.error(jqXHR);
        alert(
          "An error occurred while attempting to fetch prices. Please try again."
        );
      }
    });
  } else {
    $("#payment-container").hide();
  }
}

function update_prices(data) {
  $("#order_total_tax").html(data.total_tax);
  $("#order_total_due").html(data.total_due);
}

function update_address() {
  if (get_address() !== null) {
    enable_payment_section();
  } else {
    disable_payment_section();
  }
}
