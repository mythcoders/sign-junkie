# frozen_string_literal: true

json.call(@workshop, :name, :when)
json.tickets @order_items do |item|
  json.id item.id
  json.identifier item.short_id
  json.assignee item.assignee.present? ? item.assignee.full_name : 'Not assigned'
  json.project item.description
  json.price number_to_currency(item.amount_refundable)
end
