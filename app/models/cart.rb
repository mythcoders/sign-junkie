class Cart < ApplicationRecord
  audited

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, -> { where('created_at <= CURRENT_TIMESTAMP') }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) unless date_created.nil? }

  attr_accessor :stencil_id

  serialize :item

  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  validates_presence_of :item, :user_id, :price

  def self.build(user, workshop, params)
    item = Cart.new(user_id: user.id, quantity: params[:quantity])
    item.price = workshop.ticket_price

    if item.workshop.is_public?
      item.project = workshop.projects.where(id: params[:project_id]).first
      item.seating = params[:seating]

      if params[:design_id] != '$custom'
        item.design = workshop.designs.where(id: params[:design_id]).first.name
      else
        item.design = params[:design]
      end

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
    return item

    val = workshop.name
    val << " - #{project.name}" if project_id.present?
    val << " (#{design})" if design.present?
    val << " w/ #{addon.name}" if addon_id.present?
    val
  end
end
