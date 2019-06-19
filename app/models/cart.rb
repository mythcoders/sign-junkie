class Cart < ApplicationRecord
  has_paper_trail
  belongs_to :user
  belongs_to :description, class_name: 'ItemDescription', foreign_key: 'item_description_id'

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, -> { where('created_at <= CURRENT_TIMESTAMP') }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) }
  scope :for_shop, ->(id) { includes(:description).where(item_descriptions: { workshop_id: id  }) }
  scope :non_gift_seat, -> { includes(:description).where('item_descriptions.email IS NULL') }
  scope :gifted_seats, ->(email) { includes(:description).where(item_descriptions: { email: email }) }

  delegate_missing_to :description
  validate :validate_can_book, on: :create

  def self.new_seat(user, workshop, params)
    project = workshop.projects.where(id: params[:project_id]).first!
    stencil = project.stencils.where(id: params[:stencil_id]).first!

    cart = Cart.new(user: user,
                    description: ItemDescription.seat(workshop),
                    project_id: project.id,
                    project_name: project.name,
                    stencil_id: stencil.id,
                    stencil_name: stencil.name,
                    taxable_amount: project.material_price,
                    nontaxable_amount: project.instructional_price)
    cart.stencil_personalization = params[:stencil] if params[:stencil].present?
    cart.seat_preference = params[:seating] if params[:seating].present?

    if params[:addon_id].present?
      addon = project.addons.where(id: params[:addon_id]).first
      cart.addon_id = addon.id
      cart.addon_name = addon.name
      cart.taxable_amount += addon.price
    end

    if params[:email].present?
      cart.first_name = params[:first_name]
      cart.last_name = params[:last_name]
      cart.email = params[:email]
    end

    cart
  end

  def self.new_gift_card(user, params)
    Cart.new(user: user,
             description: ItemDescription.gift_card(params),
             nontaxable_amount: params[:amount],
             taxable_amount: 0.00)
  end

  def self.new_reservation(user, workshop, params)
    Cart.new(user: user,
             description: ItemDescription.reservation(workshop, params[:quantity]),
             seats_booked: params[:quantity],
             nontaxable_amount: workshop.reservation_price,
             taxable_amount: 0.00)
  end

  private

  def seat_owner
    @seat_owner ||= gifted_seat? ? User.find_or_initialize_by(email: email) : user
  end

  def validate_can_book
    if seat?
      existing_seats = Seat.for(seat_owner).for_shop(workshop_id).any?
      existing_cart_items = Cart.for(seat_owner).for_shop(workshop_id).non_gift_seat.any?
      existing_gifts = Cart.gifted_seats(seat_owner.email).any?
      raise ProcessError, 'Workshop has already been booked or added to cart' if existing_cart_items || existing_seats || existing_gifts
    elsif reservation?
      # TODO: Can another reservation be made?
    end
  end
end

