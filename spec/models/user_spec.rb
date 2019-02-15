require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :role }
  it { should validate_length_of(:first_name).is_at_most(50) }
  it { should validate_length_of(:last_name).is_at_most(50) }
  it { should validate_length_of(:middle_name).is_at_most(25) }
end
