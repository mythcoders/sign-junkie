# frozen_string_literal: true

class PoliciesController < ApplicationController
  before_action :set_policy, only: [:show]

  def index
    @policies = Policy.all.order(:title)
  end

  private

  def set_policy
    @policy = Policy.find_by_slug(params[:slug])
  end
end
