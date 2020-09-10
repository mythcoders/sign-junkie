# frozen_string_literal: true

class AbandonedCartReminderWorker
  include Sidekiq::Worker

  def perform
    customers.each do |customer|
      CustomerMailer.with(customer_id: customer.id).abandoned_cart.deliver_later
      Appsignal.increment_counter('carts.abandoned_reminder', 1)
    end
  end

  private

  def customers
    User
      .customers
      .with_items_in_cart
      .where(created_at: Time.zone.yesterday.all_day)
  end
end
