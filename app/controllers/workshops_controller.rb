# frozen_string_literal: true

class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i[show]
  before_action :set_cart_total, only: %i[show]

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end
end
