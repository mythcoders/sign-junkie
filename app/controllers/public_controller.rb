class PublicController < ApplicationController
  before_action :authenticate_user!, only: %i(my_account)

  def faq
    @questions = YAML.load_file(faq_file_path)
  end

  private

  def faq_file_path
    Rails.root.join('lib', 'faq.yaml')
  end
end
