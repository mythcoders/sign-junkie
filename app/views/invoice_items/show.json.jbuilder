json.id @order_item.id
json.identifier @order_item.short_id
json.assignee @order_item.assignee.present? ? item.assignee.full_name : 'Not assigned'
json.workshop @order_item.workshop.name
json.when @order_item.workshop.when
json.description @order_item.description
