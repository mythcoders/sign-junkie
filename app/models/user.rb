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
  has_many :email_logs, dependent: :destroy
  has_many :invoices, dependent: :restrict_with_error
  has_many :seats, dependent: :restrict_with_error
  has_many :reservations, dependent: :restrict_with_error

  validates_presence_of :first_name, :last_name, :role
  validates :email, presence: true, uniqueness: true, email: true

  scope :recently_created, -> { customers.where('created_at > ?', Time.zone.now - 24.hours) }
  scope :customers, -> { where('role = ?', User.roles[:customer]) }
  scope :employees, -> { where('role <> ?', User.roles[:customer]) }
  scope :with_items_in_cart, -> { joins(:carts).distinct }

  def self.system_admin
    email = Rails.env.production? ? ClientInfo.contact_email : SystemInfo.support_key
    User.where(email: email).first
  end

  def self.find_or_invite(first_name, last_name, email)
    user = User.where('email ILIKE ?', email).first
    if user.nil?
      user = User.invite!(email: email,
                          first_name: first_name,
                          last_name: last_name,
                          role: 'customer')
    end

    user
  end

  def associated_reservations
    Reservation.attending(id)
  end

  def astronaut?
    employee? || admin? || operator?
  end

  def may_upgrade_operator?
    operator?
  end

  def cart_total
    Cart.for(self).count
  end

  def credit_balance
    (credits.active.map(&:balance).reduce(:+) || 0.00).round(2)
  end

  def status
    if locked_at.present?
      { title: :locked, date: locked_at }
    elsif confirmed_at.present?
      { title: :confirmed, date: confirmed_at }
    elsif invitation_sent_at.present?
      { title: :invited, date: invitation_sent_at }
    elsif confirmation_sent_at.present?
      { title: :pending, date: confirmation_sent_at }
    end
  end
end
