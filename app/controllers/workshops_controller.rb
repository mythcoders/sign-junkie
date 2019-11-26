# frozen_string_literal: true

class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i[show project_info]

  def public
    @workshops = Workshop.includes(:workshop_type)
                         .where(workshop_types: { name: 'Public' })
                         .for_sale
                         .order(:start_date)
  end

  def private
    @workshops = Workshop.includes(:workshop_type)
                         .where(workshop_types: { name: 'Private' })
                         .for_sale
                         .order(:start_date)
  end

  def project_info
    @project = Project.find(params[:project_id])
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end
end
