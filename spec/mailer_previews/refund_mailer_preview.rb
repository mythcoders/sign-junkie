# frozen_string_literal: true

class RefundMailerPreview < ActionMailer::Preview
  def issued
    RefundMailer.with(refund: Refund.first).issued
  end
end
