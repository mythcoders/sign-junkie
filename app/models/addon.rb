class Addon < ApplicationRecord
  belongs_to :project

  def formatted_name
    "#{name} - #{number_to_currency(price)}"
  end
end
