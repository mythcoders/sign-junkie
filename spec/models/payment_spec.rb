# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  it { should validate_presence_of :method }
  it { should validate_presence_of :amount }
end
