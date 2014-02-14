class ZendeskTicket::TicketsController < ActionController::Base
  respond_to :json
  layout :false

  def create
    ticket = Ticket.new ticket_params
    if ticket.save
      render json: { message:  I18n.t('created', scope: 'zendesk_ticket.ticket.success'), ticket: { url: ticket.url } }, status: :created
    else
      render json: { errors: ticket.errors }, status: :unprocessable_entity
    end
  end

  def ticket_params
    params.require(:ticket).permit :username, :description, :subject
  end
end
