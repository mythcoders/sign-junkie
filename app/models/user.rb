# frozen_string_literal: true

class User < ApplicationRecord
  include Nameable
  has_paper_trail ignore: %i[current_sign_in_at last_sign_in_at sign_in_count
                     last_sign_in_ip current_sign_in_ip failed_attempts
                     encrypted_password reset_password_token confirmation_token]
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :confirmable, :lockable, :timeoutable, :invitable

  enum role: {
    customer: 'customer',
    employee: 'employee',
    admin: 'admin',
    operator: 'operator'
  }
  has_many :credits, class_name: 'CustomerCredit'
  has_many :carts
  has_many :invoices
  has_many :seats

  validates_presence_of :first_name, :last_name, :role

  scope :recently_created, lambda {
    where('created_at > ? AND role = ?', Time.now - 24.hours, User.roles[:customer])
  }
  scope :customers, -> do
    where('role = ?', User.roles[:customer])
  end
  scope :employees, -> do
    where('role <> ?', User.roles[:customer])
  end

  def can_cp?
    employee? || admin? || operator?
  end

  def can_upgrade_operator?
    operator?
  end

  def cart_total
    Cart.for(self).count
  end

  def credit_balance
    (credits.active.map(&:balance).reduce(:+) || 0.00).round(2)
  end
end
