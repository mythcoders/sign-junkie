$(function() {
    update_ui();
});

$.onmount("[data-js-change-project]", function() {
    $(this).on("change", function() {
        update_ui();
        update_price();
    })
});

$.onmount("[data-js-change-design]", function() {
    $(this).on("change", function() {
        if ($(this).val() === '$custom') {
            $('[data-js-custom-design]').show();
        } else {
            $('[data-js-custom-design]').hide();
        }
    })
});

$.onmount("[data-js-change-addon]", function() {
    $(this).on("change", function() {
        update_price()
    })
});

function update_price() {
    price = parseFloat(document.getElementById('ticket-price').value)
    select = document.querySelectorAll('[data-js-change-addon]')[0]
    if (select.selectedIndex > 0) {
        addon = select[select.selectedIndex]
        price += parseFloat(addon.getAttribute('price'))
    }
    document.getElementById('total-price').innerHTML = '$' + price.toFixed(2)
}

function update_ui() {
    var project = get_project();
    if (project !== null) {
        $.ajax({
            url: "/projects/" + project,
            method: "GET",
            dataType: "json",
            cache: "false",
            success: function(data, textStatus, jQxhr) {
                if (data.addons !== null && data.addons.length > 0) {
                    $("[data-js-change-addon]").find('option').remove()
                    $("[data-js-change-addon]").append("<option value=''>- Select an optional addon -</option>")
                    for(var i = 0; i < data.addons.length; i++) {
                        $("[data-js-change-addon]").append($('<option>', {
                            value: data.addons[i].id,
                            text: data.addons[i].name,
                            price: data.addons[i].price
                        }));
                    }
                    $("[data-js-change-addon]").removeAttr("disabled");
                } else {
                    disable_addons("No addons for project");
                }

                var currentDesigns = document.querySelector('[data-js-change-design]')
                while (currentDesigns.options.length > 1) {
                    currentDesigns.remove(currentDesigns.options.length - 1)
                }

                var value = get_design()
                console.log(value)
                for (var i = 0; i < data.designs.length; i++) {
                    var option = document.createElement('option')
                    option.text = data.designs[i].name
                    option.value = data.designs[i].id

                    if (option.text === value) {
                        option.selected = true;
                    }

                    currentDesigns.add(option)
                }

                var customOption = document.createElement('option')
                customOption.text = '- Custom design -'
                customOption.value = '$custom'

                console.log(currentDesigns.selectedIndex)
                if (value !== '' && currentDesigns.selectedIndex === 0) {
                    customOption.selected = true
                    document.querySelector('[data-js-custom-design]').style.display = 'block'
                }

                currentDesigns.add(customOption)
                currentDesigns.disabled = false;
            },
            error: function(data, textStatus, jQxhr) {
                alert('error');
            }
        });
    } else {
        disable_designs("- Select Project -");
        disable_addons("- Select Project -");
    }
}

function disable_designs(message) {
    $("[data-js-change-design]").find('option').remove()
    $("[data-js-change-design]").append("<option value=''>"+ message + "</option>")
    $("[data-js-change-design]").attr("disabled", "disabled");
}

function disable_addons(message) {
    $("[data-js-change-addon]").find('option').remove()
    $("[data-js-change-addon]").append("<option value=''>"+ message + "</option>")
    $("[data-js-change-addon]").attr("disabled", "disabled");
}

function get_project() {
    return document.querySelector('[data-js-change-project]').value || null;
}

function get_design() {
    return document.querySelector('[data-js-custom-design-input]').value || null;
}
