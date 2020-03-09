# frozen_string_literal: true

class GuestListReport
  def initialize(params)
    workshop = Workshop.find params[:workshop_id]
    @workshop_id = workshop.id
    @workshop_name = workshop.name_with_date
  end

  attr_reader :workshop_id, :workshop_name

  def raw_data
    return nil if customers.nil?

    @raw_data ||= customers
  end

  private

  def customers
    Seat.joins(:customer)
        .where(workshop_id: workshop_id)
        .order(:last_name)
  end
end
