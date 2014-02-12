class ZendeskTicket::TicketsController < ActionController::Base
  require 'zendesk_api'
  
  respond_to :json
  layout :false

  def create
    ticket = ::ZendeskAPI::Ticket.new(client)
    ticket.subject = ticket_params[:subject]
    ticket.description = ticket_params[:description]
    ticket.submitter_id = client.current_user.id

    if ticket.save
      render json: {
        message: 'Bedankt, we nemen zo spoedig mogelijk contact met u op!'
      }, status: :created
    else
      render json: ticket.errors.to_json, status: :unprocessable_entity
    end
  end

  def index
    raise 'hoi'
  end
  private
  def client
    client = ::ZendeskAPI::Client.new do |config|
      config.url = ZendeskTicket.url
      config.username = ticket_params[:username]
      config.token = ZendeskTicket.api_token
    end

    client
  end

  def ticket_params
    params.require(:ticket).permit :username, :description, :subject
  end
end
