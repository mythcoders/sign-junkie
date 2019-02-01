# frozen_string_literal: true

json.array! @addons do |addon|
  json.id addon.id
  json.name "#{addon.name} - #{number_to_currency(addon.price)}"
end
