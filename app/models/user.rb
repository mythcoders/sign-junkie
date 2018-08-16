# frozen_string_literal: true

class User < ApplicationRecord
  include Nameable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable, :timeoutable

  enum role: {
    customer: 'customer',
    employee: 'employee',
    admin: 'admin',
    operator: 'operator'
  }
  has_many :addresses
  has_many :cart_items
  has_many :notes
  has_many :orders

  accepts_nested_attributes_for :addresses, allow_destroy: true
  validates_presence_of :first_name, :last_name, :role

  scope :recently_created, lambda {
    where('created_at > ? AND role = ?', Time.now - 24.hours, User.roles[:customer])
  }
  scope :employees, -> do
    where('role <> ?', User.roles[:customer])
  end

  def can_cp?
    employee? || admin? || operator?
  end
end
