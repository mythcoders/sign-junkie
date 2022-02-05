# frozen_string_literal: true

module WorkshopsHelper
  def sold_out_text(workshop)
    if workshop.reservations_allowed? && !workshop.multiple_reservations_allowed?
      "BOOKED!"
    else
      "SOLD OUT!"
    end
  end

  def workshop_type_name(workshop)
    return "#{workshop.workshop_type.name} Family Friendly" if workshop.family_friendly?

    workshop.workshop_type.name
  end

  def image_for_workshop(workshop)
    if workshop.workshop_images.any?
      url_for workshop.workshop_images.first
    else
      asset_path "cover.jpg"
    end
  end
end
