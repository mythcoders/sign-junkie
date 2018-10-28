# frozen_string_literal: true

require 'json'
module Admin
  class AuditsController < AdminController
    def index
      @audits = Audited::Audit.order(created_at: :desc).page(params[:page])
    end

    def show
      @audit = Audited::Audit.find(params[:id])
      @changes = JSON.pretty_generate(@audit.audited_changes)
    end
  end
end
