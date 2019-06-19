$(function() {
    if (document.getElementById('cart_workshop_id')) {
        update_ui();
    }
});

$.onmount("[data-js-change-project]", function() {
    $(this).on("change", function() {
        update_ui();
    })
});

$.onmount("[data-js-gift-seat]", function() {
    $(this).on("change", function(event) {
        if (event.target.checked) {
            $("[data-js-seat-info]").show();
        } else {
            $("[data-js-seat-info]").hide();
        }
        $("#cart_first_name").attr("required", event.target.checked);
        $("#cart_last_name").attr("required", event.target.checked);
        $("#cart_email").attr("required", event.target.checked);
    })
});

$.onmount("[data-js-change-addon]", function() {
    $(this).on("change", function() {
        price = parseFloat(document.getElementById('base-price').value);
        select = document.querySelectorAll('[data-js-change-addon]')[0]
        if (select.selectedIndex > 0) {
            addon = select[select.selectedIndex];
            price += parseFloat(addon.getAttribute('price'));
        }
        document.getElementById('total-price').innerHTML = '$' + price.toFixed(2);
    })
});

function update_ui() {
    var workshop = get_workshop();
    var project = get_project();

    if (workshop !== null && project !== null) {
        $.ajax({
            url: "/projects/" + project + "?workshop_id=" + workshop,
            method: "GET",
            dataType: "json",
            cache: "false",
            success: function(data, textStatus, jQxhr) {
                var total_price = Number(data.instructional_price) + Number(data.material_price);
                document.getElementById('base-price').value = total_price.toFixed(2);
                document.getElementById('total-price').innerHTML = '$' + total_price.toFixed(2);

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

                var currentStencils = document.querySelector('[data-js-change-stencil]')
                var blankoption = document.createElement('option')
                blankoption.text = '- Select a stencil design -'
                blankoption.value = ''
                while (currentStencils.hasChildNodes()) {
                    currentStencils.removeChild(currentStencils.lastChild);
                }
                currentStencils.appendChild(blankoption)

                var value = get_stencil()
                for (var i = 0; i < data.stencils.length; i++) {
                    var category = data.stencils[i]

                    if (category.name === '') {
                        append_stencils(category, currentStencils, value)
                    } else {
                        var group = document.createElement('optgroup')
                        group.label = category.name
                        append_stencils(category, group, value)
                        currentStencils.append(group)
                    }
                }

                preview = document.querySelector('[data-js-project-preview]')
                preview.classList.remove('disabled')
                preview.href = '/projects/' + project

                $("[data-js-custom-stencil-input]").removeAttr("disabled");
                currentStencils.selectedValue = null;
                currentStencils.disabled = false;
            },
            error: function(data, textStatus, jQxhr) {
                Raven.captureException(jQxhr);
                alert('An error occured. Please try again.');
            }
        });
    } else {
        disable_stencils("- Select Project -");
        disable_addons("- Select Project -");
    }
}

function append_stencils(category, group, selected_stencil) {
    for (var j = 0; j < category.stencils.length; j++) {
        var option = document.createElement('option')
        option.text = category.stencils[j].name
        option.value = category.stencils[j].id

        if (option.text === selected_stencil) {
            option.selected = true;
        }

        group.append(option)
    }
}

function disable_stencils(message) {
    $("[data-js-change-stencil]").find('option').remove()
    $("[data-js-change-stencil]").append("<option value=''>"+ message + "</option>")
    $("[data-js-change-stencil]").attr("disabled", "disabled");
    $("[data-js-custom-stencil-input]").attr("disabled", "disabled");
}

function disable_addons(message) {
    $("[data-js-change-addon]").find('option').remove()
    $("[data-js-change-addon]").append("<option value=''>"+ message + "</option>")
    $("[data-js-change-addon]").attr("disabled", "disabled");
}

function get_project() {
    return document.querySelector('[data-js-change-project]').value || null;
}

function get_stencil() {
    return document.querySelector('[data-js-custom-stencil-input]').value || null;
}

function get_workshop() {
    return document.getElementById('cart_workshop_id').value || null;
}

function get_addon() {
    return document.querySelector('[data-js-change-addon]').value || null;
}
