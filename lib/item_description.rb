class ItemDescription
  ITEM_TYPES = %i[seat reservation]
  attr_accessor :type, :workshop_name, :workshop_id, :project, :project_id, :stencil, :stencil_id,
                :addon, :addon_id, :seat_quantity, :seat_preference, :design_agreement,
                :policy_agreement

  def self.seat(workshop, project = nil, seat_preference = nil)
    item = ItemDescription.new
    item.type = :seat
    item.workshop_name = workshop.name
    item.workshop_id = workshop.id
    item.project = project.name
    item.project_id = project.id
    item.seat_preference = seat_preference
    item
  end

  def self.reservation(workshop, seat_quantity)
    item = ItemDescription.new
    item.type = :reservation
    item.workshop_name = workshop.name
    item.workshop_id = workshop.id
    item.seat_quantity = seat_quantity
    item
  end

  def title
    if seat?
      val = workshop_name
      val << " - #{project}" if project.present?
      val << " (#{stencil})" if stencil.present?
      val << " w/ #{addon}" if addon.present?
      val
    elsif reservation?
      "Reservation for #{workshop_name}"
    else
      workshop_name
    end
  end

  def seat_info
    return unless seat?

    val = project
    val << " (#{stencil})" if stencil.present?
    val << " w/ #{addon}" if addon.present?
    val << "\nSeat: #{seat_preference}" if seat_preference.present?
    val
  end

  def workshop
    @workshop ||= Workshop.find workshop_id
  end

  ITEM_TYPES.each do |item_type|
    define_method "#{item_type}?" do
      type == item_type
    end
  end
end

