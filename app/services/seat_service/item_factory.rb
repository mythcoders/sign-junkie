# frozen_string_literal: true

module SeatService
  # builds an ItemDescription of type Seat
  class ItemFactory
    def initialize(workshop, params)
      @workshop = workshop
      @params = Hashie::Mash.new(params)
    end

    def self.build(workshop, params)
      new(workshop, params).perform
    end

    def perform
      @item = base_item
      apply_owner
      apply_addon if @params.addon_id.present?
      apply_stencils if @params.stencils.present?

      @item
    end

    private

    def base_item
      ItemDescription.new(item_type: :seat,
                          identifier: SecureRandom.uuid,
                          workshop_name: @workshop.name,
                          workshop_id: @workshop.id,
                          project_id: project.id,
                          project_name: project.name,
                          taxable_amount: project.material_price,
                          nontaxable_amount: project.instructional_price)
    end

    def project
      @project ||= @workshop.projects.active.find @params.project_id
    end

    def addon
      @addon ||= project.addons.active.find @params.addon_id
    end

    def apply_stencils
      @item.stencils = SeatService::StencilParser.parse(project.id, @params.stencils)
    end

    def apply_addon
      @item.addon_id = addon.id
      @item.addon_name = addon.name
      @item.taxable_amount += addon.price
    end

    def apply_owner
      @item.owner = SeatService::GuestParser.parse(@params)
      @item.seat_preference = @params.seat_preference
      @item.for_child = @params.guest_type == 'child'
      @item.gifted = @params.guest_type != 'self'
    end
  end
end