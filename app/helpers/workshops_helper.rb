# frozen_string_literal: true

module WorkshopsHelper
  def starting_price(workshop)
    if workshop.projects.any?
      workshop.projects.pluck(:material_price, :instructional_price).map(&:sum).min
    else
      0.00
    end
  end

  def sold_out_text(workshop)
    return 'BOOKED!' if private?(workshop)

    'SOLD OUT!'
  end

  def workshop_policies_path(workshop)
    return private_policies_path if private?(workshop)

    policies_path
  end

  def workshop_hosting_path(workshop)
    return private_hostess_path if private?(workshop)

    workshops_bookings_path
  end

  private

  def private?(workshop)
    workshop.workshop_type.name.include? 'Private'
  end
end
