module Services
  class Tax
    SALES_TAX_ENABLED = true

    def self.current_rate
      BigDecimal.new("0.0725")
    end

    def self.enabled?
      Tax.current_rate.positive?
    end

    def apply_tax!(item)
      amount_taxable = calc_taxable(item)
      if amount_taxable.positive?
        item.tax_rate = Tax.current_rate
        item.tax_amount = (amount_taxable * item.tax_rate).round(2)
      else
        item.tax_rate = nil
        item.tax_amount = nil
      end
    end

    def calc_taxable(item)
      return 0.00 unless Tax.enabled?
      return 0.00 if item.reservation?

      taxable = Project.find(item.project_id).price

      if item.addon_id.present?
        addon = ProjectAddon.find item.addon_id
        taxable += addon.price
      end

      taxable
    end
  end
end
