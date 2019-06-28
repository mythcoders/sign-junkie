# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stencil, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :category }
end
