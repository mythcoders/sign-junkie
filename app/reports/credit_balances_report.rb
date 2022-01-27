# frozen_string_literal: true

class CreditBalancesReport
  def initialize(params)
    @include_zero_balances = params[:include_zero_balances]
  end

  def raw_data
    @raw_data ||= customer_credits
  end

  private

  def customer_credits
    scope = CustomerCredit.includes(:customer).order("users.last_name")
    return scope.all if @include_zero_balances

    scope.where("balance > 0")
  end
end
