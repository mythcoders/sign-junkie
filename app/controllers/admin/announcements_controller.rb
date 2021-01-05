# frozen_string_literal: true

module Admin
  class AnnouncementsController < AdminController
    before_action :set_announcement, only: %i[show edit update destroy]

    def index
      @q = Announcement.ransack(params[:q])
      @q.sorts = 'start_at asc' if @q.sorts.empty?
      @announcements = @q.result(distinct: true).page(params[:page])
    end

    def new
      @announcement = Announcement.new
    end

    def create
      @announcement = Announcement.new(announcement_params)

      if @announcement.save
        flash[:success] = t('create.success')
        redirect_to admin_announcement_path @announcement
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def update
      if @announcement.update(announcement_params)
        flash[:success] = t('update.success')
        redirect_to admin_announcement_path @announcement
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    def destroy
      if @announcement.destroy
        flash[:success] = t('destroy.success')
        redirect_to admin_announcements_path
      else
        flash[:error] = t('destroy.failure')
        redirect_to admin_announcement_path(@announcement)
      end
    end

    private

    def announcement_params
      parameters = params.require(:announcement).permit(:title, :content, :start_at, :end_at)
      parameters[:start_at] = convert_datetime(parameters[:start_at])
      parameters[:end_at] = convert_datetime(parameters[:end_at])
      parameters
    end

    def set_announcement
      @announcement = Announcement.find(params[:id])
    end
  end
end
