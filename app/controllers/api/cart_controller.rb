# frozen_string_literal: true

module Api
  class CartController < ApplicationController
    helper WorkshopsHelper
    before_action :authenticate_user!

    # Used by SeatPicker.vue
    def create
      raise ProcessError, t('cart.add.failure') unless cart_service.add(current_user, cart_params)

      render json: { redirect_url: cart_index_path }.to_json
    rescue ProcessError => e
      render json: { errors: [e.message] }.to_json
    end

    private

    def cart_service
      @cart_service ||= CartService.new
    end

    def cart_params
      params.permit(:quantity, :workshop_id, :project_id, :addon_id, :stencil_id, :stencil, :seating, :type,
                    :first_name, :last_name, :email, :gift_seat, :seat_id, :guest_type)
    end
  end
end
