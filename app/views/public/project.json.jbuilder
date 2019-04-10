# frozen_string_literal: true

json.(@project, :instructional_price, :material_price)

json.addons @project.addons do |addon|
  json.id addon.id
  json.name "#{addon.name} - #{number_to_currency(addon.price)}"
  json.price addon.price
end

stencils = @project.stencils.map { |s| { id: s.id, name: s.name } }

if @workshop.allow_custom_stencils
  stencils << { id: '$custom', name: '- Custom -' }
end

json.stencils stencils

