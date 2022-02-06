# frozen_string_literal: true

module WorkshopService
  class Search
    def initialize(params)
      @family_friendly = ActiveModel::Type::Boolean.new.cast(params[:family_friendly])
      @workshop_type_id = params[:workshop_type_id]
    end

    def self.perform(params)
      new(params).perform
    end

    def perform
      results = base_scope
      results = results.where(workshop_type_id: @workshop_type_id) if @workshop_type_id

      results.order(:start_date)
    end

    private

    def base_scope
      Workshop
        .includes(:workshop_type)
        .for_sale
        .where(family_friendly: @family_friendly)
    end
  end
end
