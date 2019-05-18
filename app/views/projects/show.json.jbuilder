# frozen_string_literal: true

json.(@project, :instructional_price, :material_price)

json.addons @project.addons do |addon|
  json.id addon.id
  json.name "#{addon.name} - #{number_to_currency(addon.price)}"
  json.price addon.price
end

stencils = []

@project.stencils.group_by(&:category).each do |cat, items|
  stencils << {
    name: cat.name,
    stencils: items.map { |s| { id: s.id, name: s.name  } }
  }
end

if @workshop.allow_custom_stencils
  stencils << {
    name: '',
    stencils: {
      id: '$custom',
      name: '- Custom -'
    }
  }
end

json.stencils stencils

