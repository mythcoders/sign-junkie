# frozen_string_literal: true

module Admin
  class ImagesController < ApplicationController

    before_action :get, only: %i[new create destroy]

    def create
      @event.images.attach(file_params)
      flash['success'] = t('UploadSuccess')
      redirect_to admin_event_path(@event)
    end

    def destroy
      @event.images.find(params[:id]).purge
      flash['success'] = t('DeleteSuccess')
      redirect_to admin_event_path(@event)
    end

    private

    def get
      @event = Event.find(params[:event_id])
    end

    def file_params
      params[:event][:images]
    end
  end
end
