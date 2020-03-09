# frozen_string_literal: true

class RefundService < ApplicationService
  def refund_item(item_description_id)
    Rails.logger.debug "Attempting refund of #{item_description_id}"
    item = ItemDescription.find item_description_id

    return false unless item.refundable? && item.amount_refundable.positive?

    refund = Refund.new(invoice: item.invoice, amount: item.amount_refundable)

    success = if item.reservation? # && paid_with_card?
                Rails.logger.debug 'Issuing refund via BrainTree'
                issue_card_refund(item, refund)
              else
                Rails.logger.debug 'Issuing refund as credit'
                issue_credit_refund(item, refund)
              end

    if success
      item.refund_date = Time.zone.now
      item.save! && RefundMailer.with(refund_id: refund.id).issued.deliver_later
    else
      Raven.extra_context refund: refund.attributes, item: item.attributes
      Raven.capture_exception('Unable to process refund', transaction: 'Post Refund')
      raise ProcessError, 'Unable to process refund'
    end
  end

  private

  def issue_card_refund(_item, refund)
    amount_remaining = refund.amount
    refund.invoice.payments.order(:amount).each do |payment|
      next unless payment.refundable?

      amount_refundable = payment.amount_refundable
      if amount_refundable >= amount_remaining
        return false unless BraintreeService.new.post_refund(payment, amount_remaining)

        payment.amount_refunded += amount_remaining
        amount_remaining -= amount_remaining
      else
        return false unless BraintreeService.new.post_refund(payment, amount_refundable)

        payment.amount_refunded += amount_refundable
        amount_remaining -= amount_refundable
      end

      payment.save!
      break if amount_remaining.zero?
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
