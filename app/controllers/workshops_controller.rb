# frozen_string_literal: true

class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i[show project_info]

  def show
    if UNLEASH.is_enabled? 'reservations', @unleash_context
      render 'show'
    else
      render 'workshops/old/show'
    end
  end

  def public
    @workshops = Workshop.includes(:workshop_type)
                         .where(workshop_types: { name: 'Public' })
                         .for_sale
                         .order(:start_date)
  end

  def private
    @workshops = if UNLEASH.is_enabled? 'reservations', @unleash_context
                   Workshop.includes(:workshop_type)
                           .where(workshop_types: { name: 'Private' })
                           .for_sale
                           .order(:start_date)
                 else
                   []
                 end
  end

  def project_info
    @project = Project.find(params[:project_id])
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
  end
end
