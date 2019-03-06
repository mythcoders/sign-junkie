# frozen_string_literal: true

json.designs @project.designs, :id, :name
json.addons @project.addons do |addon|
  json.id addon.id
  json.name "#{addon.name} - #{number_to_currency(addon.price)}"
  json.price addon.price
end
