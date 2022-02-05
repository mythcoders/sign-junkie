# frozen_string_literal: true

class PublicController < ApplicationController
  before_action :set_announcements, only: %i[index]
  before_action :authenticate_user!, only: %i[my_account my_credits]

  def index
    @q = Workshop.includes(:workshop_type).for_sale.ransack(params[:q])
    @q.sorts = "start_date asc" if @q.sorts.empty?
    @workshops = @q.result(distinct: true).page(params[:page])
  end

  def faq
    @questions = YAML.load_file(faq_file_path)
  end

  def my_credits
    @credits = current_user.credits.active
  end

  def contact
    @mapbox_token = Rails.application.credentials[:mapbox_api]
  end

  private

  def set_announcements
    @announcements = Announcement.active
  end

  def faq_file_path
    Rails.root.join("lib", "faq.yaml")
  end
end
