$(function() {
    update_addons();
});

$.onmount("[data-js-change-project]", function() {
    $(this).on("change", function() {
        update_addons();
    })
});

function update_addons() {
    var project = get_project();
    if (project !== null) {
        $.ajax({
            url: "/addons/" + project,
            method: "GET",
            dataType: "json",
            cache: "false",
            success: function(data, textStatus, jQxhr) {
                if (data !== null) {
                    $("[data-js-change-addon]").find('option').remove()
                    $("[data-js-change-addon]").append("<option value=''>-Select an optional addon -</option>")
                    for(var i = 0; i < data.length; i++) {
                        $("[data-js-change-addon]").append($('<option>', {
                            value: data[i].id,
                            text: data[i].name
                        }));
                    }
                    $("[data-js-change-addon]").removeAttr("disabled");
                } else {
                    disable_addons("No addons for project");
                }
            },
            error: function(data, textStatus, jQxhr) {
                alert('error');
            }
        });
    } else {
        disable_addons("- Select Project -");
    }
}

function disable_addons(message) {
    $("[data-js-change-addon]").find('option').remove()
    $("[data-js-change-addon]").append("<option value=''>"+ message + "</option>")
    $("[data-js-change-addon]").attr("disabled", "disabled");
}

function get_project() {
    return $('[data-js-change-project]').val() || null;
}
