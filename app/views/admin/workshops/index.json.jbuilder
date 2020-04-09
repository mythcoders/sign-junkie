# frozen_string_literal: true

json.workshops @workshops do |workshop|
  json.call(workshop, :id, :name, :start_date)
  json.type workshop_type_name(workshop)
  json.seating "#{workshop.seats_available}/#{workshop.total_seats}"
  json.seat_purchaseable human_boolean(workshop.seat_purchaseable?)
  json.reservation_purchaseable human_boolean(workshop.reservation_purchaseable?)
  json._link admin_workshop_path(workshop)
end
