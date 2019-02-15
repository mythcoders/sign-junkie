require 'rails_helper'

RSpec.describe Design, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :design_category }
  it { should validate_uniqueness_of :name }
end
