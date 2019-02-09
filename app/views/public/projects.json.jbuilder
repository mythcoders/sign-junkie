# frozen_string_literal: true

json.customizations @project.customizations, :id, :name
json.addons @project.addons do |addon|
  json.id addon.id
  json.name "#{addon.name} - #{number_to_currency(addon.price)}"
end
