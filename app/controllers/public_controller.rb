# frozen_string_literal: true

class PublicController < ApplicationController
  before_action :set_announcements, only: %i[index]
  before_action :authenticate_user!, only: %i[my_account my_credits]

  def faq
    @questions = YAML.load_file(faq_file_path)
  end

  def my_credits
    @credits = current_user.credits.active
  end

  def contact
    @mapbox_token = Rails.application.credentials[:mapbox_api]
  end

  def gift_cards
    flash[:info] = t("gift_cards")
    redirect_to root_path
  end

  private

  def set_announcements
    @announcements = Announcement.active
  end

  def faq_file_path
    Rails.root.join("lib", "faq.yaml")
  end
end
