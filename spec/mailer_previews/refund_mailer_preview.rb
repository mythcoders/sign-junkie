# frozen_string_literal: true

class RefundMailerPreview < ActionMailer::Preview
  def issued
    RefundMailer.with(refund_id: Refund.first.id).issued
  end
end
