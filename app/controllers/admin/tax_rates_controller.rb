module Admin
  class TaxRatesController < AdminController
    def index
      TaxRate.order(created_at: :desc).all
    end
  end
end