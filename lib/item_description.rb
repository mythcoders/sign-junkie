class ItemDescription

  ITEM_TYPES = %i[public_seat private_booking]

  attr_accessor :type, :workshop_id, :project_id, :addon_id, :stencil,
                :seating_preference, :payment_method, :seats

  def initilize

  end

  def new_public_seat(params)
    @type = :public_seat
    @workshop_id = params[:workshop_id]
    @project_id = params[:project_id]
    @addon_id = params[:addon_id]
  end

  def new_private_booking(params)
    @type = :private_booking
  end

  ITEM_TYPES.each do |item_type|
    define_method "#{item_type}?" do
      type == item_type
    end
  end
end
