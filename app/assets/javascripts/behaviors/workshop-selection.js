$(function() {
    update_ui();
});

$.onmount("[data-js-change-project]", function() {
    $(this).on("change", function() {
        update_ui();
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
                    $("[data-js-change-addon]").append("<option value=''>-Select an optional addon -</option>")
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
                if (data.customizations !== null && data.customizations.length > 0) {
                    $("[data-js-change-customization]").find('option').remove()
                    $("[data-js-change-customization]").append("<option value=''>-Select customization -</option>")
                    for(var i = 0; i < data.customizations.length; i++) {
                        $("[data-js-change-customization]").append($('<option>', {
                            value: data.customizations[i].id,
                            text: data.customizations[i].name
                        }));
                    }
                    $("[data-js-change-customization]").removeAttr("disabled");
                } else {
                    disable_customizations("No customizations for project");
                }
            },
            error: function(data, textStatus, jQxhr) {
                alert('error');
            }
        });
    } else {
        disable_customizations("- Select Project -");
        disable_addons("- Select Project -");
    }
}

function disable_customizations(message) {
    $("[data-js-change-customization]").find('option').remove()
    $("[data-js-change-customization]").append("<option value=''>"+ message + "</option>")
    $("[data-js-change-customization]").attr("disabled", "disabled");
}

function disable_addons(message) {
    $("[data-js-change-addon]").find('option').remove()
    $("[data-js-change-addon]").append("<option value=''>"+ message + "</option>")
    $("[data-js-change-addon]").attr("disabled", "disabled");
}

function get_project() {
    return $('[data-js-change-project]').val() || null;
}
