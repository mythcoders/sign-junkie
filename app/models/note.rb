class Note < ApplicationRecord
  audited
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates_length_of :content, maximum: 500
  validates_presence_of :customer, :author

  def can_edit?(user)
    user.id == author_id
  end
end
