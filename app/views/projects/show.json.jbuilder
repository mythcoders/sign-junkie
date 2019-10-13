# frozen_string_literal: true

json.call(@project, :instructional_price, :material_price, :allow_no_stencil)

json.addons @project.addons do |addon|
  json.id addon.id
  json.name "#{addon.name} - #{number_to_currency(addon.price)}"
  json.price addon.price
end

stencils = []

# Group the stencils by category, then sort by category name downcase as to ignore case
@project.stencils.group_by(&:category)
        .sort_by { |cat, _| cat[:name].downcase }
        .each do |cat, items|
  stencils << {
    name: cat.name,
    stencils: items.sort_by { |s| s.name.downcase }
                   .map { |s| { id: s.id, name: s.name } }
  }
end

json.stencils stencils
