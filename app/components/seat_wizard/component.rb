# frozen_string_literal: true

module SeatWizard
  class Component < ViewComponent::Base
    extend Forwardable

    def initialize(seat:, existing_seat_id:)
      @seat = seat
      @existing_seat_id = existing_seat_id
    end

    def_delegators :@seat, :reservation
    def_delegators :@seat, :workshop

    with_content_areas :header, :sidebar_template

    def reservation_mode?
      @reservation_mode ||= reservation.present?
    end

    def projects
      @projects ||= if @seat.guest_type == 'child'
                      @seat.workshop.projects.active
                    else
                      @seat.workshop.projects.where(only_for_children: false).active
                    end
    end

    def project
      @project ||= @seat.selection_made? ? projects.find(@seat.project_id) : nil
    end

    def addon
      @addon ||= @seat.selection_made? ? project.addons.find(@seat.addon_id) : nil
    end

    def form_attributes
      {
        method: @seat.persisted? ? :patch : :post,
        'data-controller': 'seat-wizard--component seat-wizard-sidebar--component single-form-submit',
        'data-seat-wizard--component-addon-id-value': addon_value,
        'data-seat-wizard--component-guest-type-value': @seat.guest_type,
        'data-seat-wizard--component-project-value': project_value.to_json,
        'data-seat-wizard--component-purchase-mode-value': @seat.persisted? ? 'now' : '',
        'data-seat-wizard--component-stencils-value': stencils_value,
        'data-seat-wizard--component-workshop-id-value': workshop.id,
        'data-seat-wizard--component-for-reservation-value': reservation_mode?,
        'data-seat-wizard--component-active-class': 'active',
        'data-seat-wizard--component-disabled-class': 'disabled'
      }
    end

    private

    def form_url
      if @seat.persisted?
        reservation_seat_path(@seat.reservation.id, @seat.seat.id)
      elsif reservation_mode?
        reservation_seats_path(@seat.reservation.id)
      else
        cart_index_path
      end
    end

    def project_value
      @seat.selection_made? ? { id: @seat.project_id, addons: project.addons.active.any?, preselected: true } : {}
    end

    def stencils_value
      @seat.selection_made? ? unparsed_stencils : ''
    end

    def addon_value
      @seat.selection_made? ? @seat.addon_id : nil
    end

    # converts the database value to something that's in the HTML input field
    def unparsed_stencils
      return '' unless @seat.stencils

      @seat.stencils.collect do |s|
        if s['id'].zero?
          "#{SeatWizard::StencilParser::PLAIN_STENCIL_KEY}|::"
        else
          "#{s['id']}|#{s['personalization']}"
        end
      end.join('::')
    end
  end
end
