# frozen_string_literal: true

class AdminDashboardViewModel
  def total_customers
    @total_customers ||= User.count
  end

  def new_customers
    @new_customers ||= User.recently_created.count
  end

  def total_invoices
    @total_invoices ||= Invoice.count
  end

  def recent_invoices
    @recent_invoices ||= Invoice.recently_created
  end

  def sales_today
    @sales_today ||= Payment.where("created_at > ?", Time.zone.now - 24.hours)
      .where.not(method: "gift_card")
      .sum("amount - amount_refunded")
  end

  def refunds_today
    @refunds_today ||= Refund.where("created_at > ?", Time.zone.now - 24.hours).sum(:amount)
  end

  def upcoming_workshops
    @upcoming_workshops ||= Workshop.for_sale.order(start_date: :desc)
  end

  def abandoned_carts
    @abandoned_carts ||= User.with_items_in_cart
  end
end
