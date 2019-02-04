# frozen_string_literal: true

json.valid true
json.total_tax number_to_currency(@order.total_tax)
json.total_due number_to_currency(@order.due_now)
json.total_due_unformatted @order.due_now
json.client_token @client_token
