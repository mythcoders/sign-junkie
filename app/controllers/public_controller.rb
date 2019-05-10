class PublicController < ApplicationController
  before_action :set_cart_total
  before_action :authenticate_user!, only: %i(my_account)

  def project_info
    @project = Project.find(params[:project_id])
    @workshop = Workshop.find(params[:workshop_id])
  end

  def faq
    @questions = YAML.load_file(faq_file_path)
  end

  def my_account
    # @upcoming_tickets = current_user.tickets.select { |t| t.workshop.start_date.future? }
    # @past_tickets = current_user.tickets.select { |t| !t.workshop.start_date.future? }
  end

  private

  def faq_file_path
    Rails.root.join('lib', 'faq.yaml')
  end
end
