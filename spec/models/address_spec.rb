require 'rails_helper'

RSpec.describe Address, type: :model do
  it {should belong_to(:customer)}
  it {should validate_presence_of(:nickname)}
  it {should validate_length_of(:nickname).is_at_most(10)}
  it {should validate_presence_of(:state)}
  it {should validate_presence_of(:city)}
  it {should validate_presence_of(:state)}
  it {should validate_presence_of(:zip_code)}
end
