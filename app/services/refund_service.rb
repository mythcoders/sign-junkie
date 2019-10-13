# frozen_string_literal: true

class RefundService < ApplicationService
  def refund_item(item_description_id)
    Rails.logger.debug "Attempting refund of #{item_description_id}"
    item = ItemDescription.find item_description_id

    return false unless item.refundable? && item.amount_refundable.positive?

    refund = Refund.new(invoice: item.invoice, amount: item.amount_refundable)

    success = if item.reservation? # && paid_with_card?
                Rails.logger.debug 'Issuing card refund'
                issue_card_refund(item, refund)
              else
                Rails.logger.debug 'Issuing credit refund'
                issue_credit_refund(item, refund)
              end

    if success
      item.refund_date = Time.zone.now
      item.save! && RefundMailer.with(refund: refund).issued.deliver_now
    else
      Raven.extra_context refund: refund.attributes, item: item.attributes
      Raven.capture_exception('Unable to process refund', transaction: 'Post Refund')
      raise ProcessError, 'Unable to process refund'
    end
  end

  private

  def issue_card_refund(_item, refund)
    remaining = refund.amount
    refund.invoice.payments.credit_cards.order(:amount).each do |payment|
      refundable = payment.amount_refundable
      if refundable >= remaining
        return false unless BraintreeService.new.post_refund(payment, remaining)

        payment.amount_refunded += remaining
        remaining -= remaining
      else
        return false unless BraintreeService.new.post_refund(payment, refundable)

        payment.amount_refunded += refundable
        remaining -= refundable
      end

      payment.save!
      break if remaining.zero?
    end

    refund.save!
  end

  def issue_credit_refund(_item, refund)
    refund.customer_credit = CustomerCredit.new(customer: refund.invoice.customer,
                                                starting_amount: refund.amount,
                                                balance: refund.amount)

    remaining = refund.amount
    refund.invoice.payments.each do |payment|
      refundable = payment.amount_refundable
      if refundable >= remaining
        payment.amount_refunded += remaining
        remaining -= remaining
      else
        payment.amount_refunded += refundable
        remaining -= refundable
      end

      payment.save!
      break if remaining.zero?
    end

    refund.save!
  end
end
