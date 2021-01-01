class SeatItemFactory
  def initialize(workshop, params)
    @workshop = workshop
    @params = Hashie::Mash.new(params)
  end

  def self.build(workshop, params)
    new(workshop, params).new_item
  end

  def new_item
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
    @project ||= @workshop.projects.active.where(id: @params.project_id).first!
  end

  def addon
    @addon ||= project.addons.active.where(id: @params.addon_id).first!
  end

  def apply_stencils
    @item.stencils = FrontendStencilParser.new(project.id).parse(@params.stencils)
  end

  def apply_addon
    @item.addon_id = addon.id
    @item.addon_name = addon.name
    @item.taxable_amount += addon.price
  end

  def apply_owner
    @item.guest_info = FrontendGuestParser.new(@params).parse
    @item.for_child = @params.guest_type == 'child'
    @item.gifted = @params.guest_type != 'self'
  end
end
