# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaxRate, type: :model do
  it { should validate_presence_of :rate }
  it { should validate_presence_of :effective_date }
end
