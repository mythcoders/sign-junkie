# frozen_string_literal: true

class CartCleanupWorker
  include Sidekiq::Worker

  def perform
    expired_cart_items.delete_all
  end

  private

  def expired_cart_items
    @expired_cart_items ||=
      Cart.joins("LEFT JOIN item_descriptions i on carts.item_description_id = i.id LEFT JOIN workshops w on w.id = i.workshop_id")
        .where("w.end_date < now()")
  end
end
