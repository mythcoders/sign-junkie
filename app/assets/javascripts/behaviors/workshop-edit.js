$.onmount("[data-js-workshop-type]", function () {
  $(this).on("change ready load", function () {
    console.log('direct')
    updateDefaultOptions(this);
  })
});

$(function () {
  selected = document.querySelector('input[data-js-workshop-type]:checked')
  if (selected) {
    updateDefaultOptions(selected);
  }
});

function updateDefaultOptions(option) {
  document.querySelector("[data-js-workshop-type-single-seat-allow]").textContent = $(option).data('workshop-type-single-seat-allow');
  document.querySelector("[data-js-workshop-type-reservation-allow]").textContent = $(option).data('workshop-type-reservation-allow');
  document.querySelector("[data-js-workshop-type-reservation-cancel-minimum]").textContent = $(option).data('workshop-type-reservation-cancel-minimum');
  document.querySelector("[data-js-workshop-type-reservations-end]").textContent = $(option).data('workshop-type-reservations-end');
  document.querySelector("[data-js-workshop-type-reservation-allow-multiple]").textContent = $(option).data('workshop-type-reservation-allow-multiple');
  document.querySelector("[data-js-workshop-type-total-seats]").textContent = $(option).data('workshop-type-total-seats');
  document.querySelector("[data-js-workshop-type-reservation-price]").textContent = $(option).data('workshop-type-reservation-price');
  document.querySelector("[data-js-workshop-type-reservation-minimum]").textContent = $(option).data('workshop-type-reservation-minimum');
  document.querySelector("[data-js-workshop-type-reservation-maximum]").textContent = $(option).data('workshop-type-reservation-maximum');
}