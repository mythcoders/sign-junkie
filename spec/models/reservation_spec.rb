# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reservation, type: :model do
  subject { create(:reservation) }

  describe "#may_add_seat?" do
  end

  describe "#can_add_seat?" do
  end

  describe "#payment_deadline" do
  end

  describe "#minimum_seats" do
  end

  describe "#maximum_seats" do
  end

  describe "#host?" do
  end

  describe "#paid_by_host?" do
    context "when to be paid by host" do
      let(:payment_plan) { "host" }
    end

    context "when guests are responsible for paying" do
      let(:payment_plan) { "guest" }
    end
  end

  describe "#requirements_met?" do
  end

  describe "#remaining_seats_until_requirements_met" do
  end

  describe "#minimum_met?" do
  end

  describe "#remaining_seats_until_minimum_met" do
  end

  describe "#remaining_seats" do
  end

  describe "#balance" do
  end

  describe "#unpaid_balance" do
  end

  describe "#unpaid_seats" do
  end

  describe "#active_seats" do
  end

  describe "#paid_seats" do
  end
end
