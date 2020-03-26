# frozen_string_literal: true

json.call(@workshop, :id, :name)
json.seat_purchaseable @workshop.seat_purchaseable?
json.reservation_purchaseable @workshop.reservation_purchaseable?

json.projects @workshop.projects do |project|
  json.call(project, :instructional_price, :material_price, :prohibit_adult_purchases, :stencil_optional, :max_stencil_selection)

  json.addons project.addons do |addon|
    json.id addon.id
    json.name "#{addon.name} - #{number_to_currency(addon.price)}"
    json.price addon.price
  end

  stencils = []

  # Group the stencils by category, then sort by category name downcase as to ignore case
  project.stencils.group_by(&:category)
         .sort_by { |cat, _| cat[:name].downcase }
         .each do |cat, items|
    stencils << {
      category_name: cat.name,
      stencils: items.sort_by { |s| s.name.downcase }
                     .map do |s|
                  {
                    id: s.id,
                    name: s.name,
                    personilization_allowed: s.allow_personilization
                  }
                end
    }
  end

  json.stencils stencils
end
