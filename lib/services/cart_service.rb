class CartService
  def add(user, cart_params)
    workshop = Workshop.includes(:projects).find(cart_params[:workshop_id])
    return false unless workshop.can_purchase?

    cart = if workshop.is_public?
             public_seat user, workshop, cart_params
           else
             private_booking user, workshop, cart_params
           end

    cart.save!
  end

  private

  def public_seat(user, workshop, params)
    project = workshop.projects.where(id: params[:project_id]).first
    item = Cart.new(user: user,
                    price: workshop.ticket_price + project.price,
                    quantity: params[:quantity])
    item.description = ItemDescription.new(type: :public_seat,
                                           workshop_id: workshop.id,
                                           project: project.name,
                                           seating: params[:seating])

    if params[:stencil_id] == '$custom'
      item.description.stencil = params[:stencil]
    else
      item.description.stencil = project.stencils.where(id: params[:stencil_id]).first.name
    end

    if params[:addon_id].present?
      addon = project.addons.where(id: params[:addon_id]).first
      item.description.addon = addon.name
      item.price += addon.price
    end

    item
  end


  def private_booking(user, workshop, params)
    item = Cart.new(user: user,
                    price: workshop.deposit_price,
                    quantity: 1)
    item.description = ItemDescription.new(type: :private_booking,
                                           workshop_id: workshop.id,
                                           seats: params[:quantity])

    item
  end
end
