require 'rails_helper'

RSpec.describe Note, type: :model do
  it { should belong_to(:author) }
  it { should belong_to(:customer) }
  it { should validate_length_of(:content).is_at_most(500)}
  it { should validate_presence_of(:author)}
  it { should validate_presence_of(:customer)}

end
