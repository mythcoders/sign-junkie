$(function() {
    update_ui();
});

$.onmount("[data-js-change-project]", function() {
    $(this).on("change", function() {
        update_ui();
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
                            text: data.addons[i].name
                        }));
                    }
                    $("[data-js-change-addon]").removeAttr("disabled");
                } else {
                    disable_addons("No addons for project");
                }

                $("[data-js-change-design]").find('option').remove()
                $("[data-js-change-design]").append("<option value=''>- Select design -</option>")
                for(var i = 0; i < data.designs.length; i++) {
                    $("[data-js-change-design]").append($('<option>', {
                        value: data.designs[i].id,
                        text: data.designs[i].name
                    }));
                }
                $("[data-js-change-design]").removeAttr("disabled");
                $("[data-js-change-design]").append("<option value='$custom'>- Custom design -</option>")
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
    return $('[data-js-change-project]').val() || null;
}
