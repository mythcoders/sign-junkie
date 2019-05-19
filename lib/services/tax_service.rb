module Services
  class TaxService
    def self.current_rate
      tax = TaxRate.where('effective_date <= CURRENT_TIMESTAMP')
                   .order(effective_date: :desc)
                   .first
      return 0 if tax.nil?

      tax.rate
    end

    def self.enabled?
      TaxService.current_rate.positive?
    end

    def apply_tax!(item)
      taxable = calc_amount_taxable(item.description)
      if taxable.positive?
        item.tax_rate = TaxService.current_rate
        item.tax_amount = (taxable * item.tax_rate).round(2)
      else
        item.tax_rate = nil
        item.tax_amount = 0.00
      end
    end

    def calc_amount_taxable(item)
      return 0.00 unless TaxService.enabled?
      return 0.00 unless item.taxable?

      taxable = Project.find(item.project_id).material_price

      if item.addon_id.present?
        addon = Addon.find item.addon_id
        taxable += addon.price
      end

      taxable
    end

    def calc_tax(item)
      (calc_amount_taxable(item) * TaxService.current_rate).round(2)
    end
  end
end
