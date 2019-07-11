# frozen_string_literal: true

json.call(@project, :instructional_price, :material_price)

json.addons @project.addons do |addon|
  json.id addon.id
  json.name "#{addon.name} - #{number_to_currency(addon.price)}"
  json.price addon.price
end

stencils = []

@project.stencils.group_by(&:category).sort.each do |cat, items|
  stencils << {
    name: cat.name,
    stencils: items.sort.map { |s| { id: s.id, name: s.name } }
  }
end

json.stencils stencils
