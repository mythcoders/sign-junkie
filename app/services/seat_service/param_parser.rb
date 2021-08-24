# frozen_string_literal: true

module SeatService
  # called when creating or updating a seat on a reservation
  class ParamParser
    def initialize(raw_params, current_user)
      @raw_params = raw_params
      @current_user = current_user
    end

    def self.perform(raw_params, current_user)
      new(raw_params, current_user).perform
    end

    def perform
      return @raw_params unless @raw_params[:first_name].blank?

      params_with_current_user_info
    end

    private

    def params_with_current_user_info
      @raw_params.merge(first_name: @current_user.first_name,
        last_name: @current_user.last_name,
        email: @current_user.email)
    end
  end
end
