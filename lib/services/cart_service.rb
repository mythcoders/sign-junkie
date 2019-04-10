module Services
  class CartService

    def add(user, cart_params)
      workshop = Workshop.includes(:projects).find(cart_params[:workshop_id])
      return false unless workshop.can_purchase?

      cart = if workshop.is_public?
               new_seat user, workshop, cart_params
             else
               new_reservation user, workshop, cart_params
             end
      cart.save!
    end

    def update(user, cart_params)
      cart = Cart.find(cart_params[:id])
      return false if user.id != cart.user_id

      # TODO: make sure not adding more than what's available

      cart.update!(quantity: cart_params[:quantity])
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

    def new_seat(user, workshop, params)
      project = workshop.projects.where(id: params[:project_id]).first
      raise ProcessError, 'No project selected' if project.nil?
      raise ProcessError, 'Please select all confirmations' unless agreements_checked?(params)

      cart = Cart.new(user: user,
                      quantity: params[:quantity],
                      price: project.instructional_price + project.material_price)
      cart.description = ItemDescription.seat(workshop, project, params[:seating])

      set_stencil(cart, project, params[:stencil_id], params[:stencil])
      set_addon(cart, project, params[:addon_id]) if params[:addon_id].present?

      cart
    end

    def new_reservation(user, workshop, params)
      cart = Cart.new(user: user,
                      quantity: 1,
                      price: workshop.reservation_price)
      cart.description = ItemDescription.reservation(workshop, params[:quantity])
      cart
    end

    def set_addon(cart, project, addon_id)
      addon = project.addons.where(id: addon_id).first
      cart.description.addon_id = addon.id
      cart.description.addon = addon.name
      cart.price += addon.price
    end

    def set_stencil(cart, project, stencil_id, custom_stencil)
      if stencil_id == '$custom'
        cart.description.stencil = custom_stencil
      else
        stencil = project.stencils.where(id: stencil_id).first
        cart.description.stencil_id = stencil.id
        cart.description.stencil = stencil.name
      end
    end

    def agreements_checked?(params)
      return false if params[:design_confirmation].nil? || params[:policy_agreement].nil?
      return false if params[:design_confirmation] == "0" || params[:policy_agreement] == "0"

      true
    end
  end
end
