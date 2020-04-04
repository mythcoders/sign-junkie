# frozen_string_literal: true

json.call(@workshop, :id, :name, :family_friendly)
json.type @workshop.workshop_type.name
json.seat_purchaseable @workshop.seat_purchaseable?
json.reservation_purchaseable @workshop.reservation_purchaseable?
json.remaining_seats @workshop.seats_available
json.purchase_end_date special_date(@workshop.purchase_end_date)

json.policies_path workshop_policies_path @workshop
json.hosting_path workshop_hosting_path @workshop

json.projects @workshop.projects do |project|
  json.call(project, :id, :name, :prohibit_adult_purchases, :stencil_optional, :max_stencil_selection)
  json.price project.instructional_price + project.material_price

  json.addons project.addons do |addon|
    json.id addon.id
    json.name "#{addon.name} - #{number_to_currency(addon.price)}"
    json.price addon.price
  end

  json.stencils project.stencils_by_category
end
