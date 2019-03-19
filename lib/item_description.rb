class ItemDescription

  ITEM_TYPES = %i[public_seat private_booking]

  attr_accessor :type, :workshop_id, :project_id, :addon_id, :stencil,
                :seating_preference, :payment_method, :seats

  ITEM_TYPES.each do |item_type|
    define_method "#{item_type}?" do
      type == item_type
    end
  end
end
