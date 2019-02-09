require 'rails_helper'

RSpec.describe Customization, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :category }
  it { should validate_uniqueness_of :name }
end
