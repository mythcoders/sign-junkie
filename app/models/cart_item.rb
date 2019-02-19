class CartItem < ApplicationRecord
  audited

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, -> { where('created_at <= CURRENT_TIMESTAMP') }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) unless date_created.nil? }

  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :workshop
  belongs_to :addon, required: false
  belongs_to :project, required: false
  belongs_to :design, required: false

  validates_presence_of :workshop_id, :user_id, :price
  before_validation :project_design_required_public_workshops

  def self.build(user, workshop, params)
    item = CartItem.new(user_id: user.id, workshop: workshop, quantity: params[:quantity])
    item.price = item.workshop.ticket_price

    if item.workshop.is_public?
      item.project = workshop.projects.where(id: params[:project_id]).first
      item.design = workshop.designs.where(id: params[:design_id]).first

      if params[:addon_id].present?
        item.addon = item.project.addons.where(id: params[:addon_id]).first
        item.price += item.addon.price
      end
    end

    item
  end

  def amount
    price * quantity
  end

  def display
    val = workshop.name
    val << " - #{project.name}" if project_id.present?
    val << " (#{design.name})" if design_id.present?
    val << " w/ #{addon.name}" if addon_id.present?
    val
  end

  private

  def project_design_required_public_workshops
    errors.add('', I18n.t('cart.add.failure')) if workshop.is_public? && (project.nil? || design.nil?)
  end
end
