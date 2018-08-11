class Address < ApplicationRecord
  audited
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :nickname, :state, :city, :state, :zip_code
  validates_length_of :nickname, maximum: 10

  def display_formatted(format)
    delimiter = format == 2 ? ', ' : '<br/>'
    val = street.blank? ? '' : street
    unless street2.blank?
      val << delimiter unless val.empty?
      val << street2
    end
    unless city.blank? && state.blank? && zip_code.blank?
      val << delimiter unless val.empty?
      unless city.blank?
        val << city
        val << ', ' unless state.blank? && zip_code.blank?
      end
      val << state unless state.blank?
      unless zip_code.blank?
        val << ' ' unless state.nil?
        val << if zip_code.length == 9
                 "#{zip_code[0..5]}-#{zip_code[5..4]}"
               else
                 zip_code
               end
      end
    end
    val
  end
end
