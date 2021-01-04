# frozen_string_literal: true

module SeatWizard
  class Component < ViewComponent::Base
    extend Forwardable

    def initialize(seat:, already_attending:)
      @seat = seat
      @already_attending = already_attending
    end

    def_delegators :@seat, :reservation
    def_delegators :@seat, :workshop

    with_content_areas :header, :sidebar_template

    def reservation_mode?
      @reservation_mode ||= reservation.present?
    end

    def projects
      @projects ||= @seat.workshop.projects.active
    end

    def project
      @project ||= projects.find @seat.project_id
    end

    def form_attributes
      {
        method: @seat.persisted? ? :patch : :post,
        'data-controller': 'seat-wizard--component seat-wizard-sidebar--component',
        'data-seat-wizard--component-workshop-id-value': workshop.id,
        'data-seat-wizard--component-project-value': project_json_value,
        'data-seat-wizard--component-active-class': 'active',
        'data-seat-wizard--component-disabled-class': 'disabled'
      }
    end

    def form_url
      if @seat.persisted?
        reservation_seats_path(@seat.reservation.id, @seat.id)
      elsif reservation_mode?
        reservation_seats_path(@seat.reservation.id)
      else
        cart_index_path
      end
    end

    def project_json_value
      @seat.selection_made? ? { id: @seat.project_id }.to_json : {}.to_json
    end
  end
end
