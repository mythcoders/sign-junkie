# frozen_string_literal: true

module Admin
  class NotesController < ApplicationController

    before_action :get, only: %i[edit show update]

    def new
      @note = Note.new(user_id: params[:customer_id])
      @note.customer = User.find(@note.user_id)
    end

    def create
      @note = Note.new(note_params)
      @note.author_id = current_user.id
      if @note.save
        flash['success'] = t('CreateSuccess')
        redirect_to admin_customer_path @note.customer
      else
        render 'new'
      end
    end

    def update
      if @note.update(note_params)
        flash['success'] = t('UpdateSuccess')
        redirect_to admin_customer_path @note.customer
      else
        render 'edit'
      end
    end

    private

    def get
      @note = Note.includes(:customer, :author).find(params[:id])
    end

    def note_params
      params.require(:note).permit(:id, :user_id, :author_id, :content, :is_flagged)
    end
  end

end