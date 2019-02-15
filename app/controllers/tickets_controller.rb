class TicketsController < ApplicationController
  before_action :set_ticket

  def edii

  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params

  end
end
