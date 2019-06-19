class CartService
  def add(user, cart_params)
    cart = if cart_params[:type] == 'gift_card'
             Cart.new_gift_card(user, cart_params)
           else
             add_item user, cart_params
           end
    cart.save
  end

  def remove(user, cart_params)
    cart = Cart.find(cart_params[:id])
    return false if user.id != cart.user_id

    cart.delete
  end

  def empty!(user, as_of = Time.now)
    Cart.for(user).as_of(as_of).delete_all
  end

  private

  def add_item(user, cart_params)
    workshop = Workshop.includes(:projects).find(cart_params[:workshop_id])
    raise ProcessError, 'Workshop is not available for purhcase' unless workshop.can_purchase?

    if workshop.is_public?
      agreements = %i(design_confirmation policy_agreement acknowledgment)
      raise ProcessError, 'Please select all confirmations' unless agreements.all? { |key| cart_params[key] == "1" }
      raise ProcessError, 'No project selected' unless cart_params[:project_id].present?
      raise ProcessError, 'No stencil selected' unless cart_params[:stencil_id].present?

      Cart.new_seat user, workshop, cart_params
    else
      Cart.new_reservation user, workshop, cart_params
    end
  end
end
