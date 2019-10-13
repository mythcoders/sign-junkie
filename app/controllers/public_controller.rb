# frozen_string_literal: true

class PublicController < ApplicationController
  before_action :authenticate_user!, only: %i[my_account my_credits]

  def faq
    @questions = YAML.load_file(faq_file_path)
  end

  def my_account
    @reservations = UNLEASH.is_enabled? 'reservations', @unleash_context
  end

  def my_credits
    @credits = current_user.credits.active
  end

  private

  def faq_file_path
    Rails.root.join('lib', 'faq.yaml')
  end
end
