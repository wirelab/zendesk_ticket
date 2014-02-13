class ZendeskTicket::TicketsController < ActionController::Base
  require 'zendesk_api'
  
  respond_to :json
  layout :false

  def create
    if is_client_authenticated?
      ticket = ::ZendeskAPI::Ticket.new(client)
      ticket.subject = ticket_params[:subject]
      ticket.description = ticket_params[:description]
      ticket.submitter_id = client.current_user.id

      if ticket.save
        render json: { message:  I18n.t('created', scope: 'zendesk_ticket.ticket.success') }, status: :created
      else
        render json: { errors: ticket.errors.to_json }, status: :unprocessable_entity
      end
    else
      render json: { 
        errors: {
          base: { 
            username: I18n.t('unauthorized', scope: 'zendesk_ticket.user.errors') 
          }
        } 
      }, status: :unauthorized
    end
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

  def is_client_authenticated?
    client.current_user.id.present? # an invalid user still returns an user object, but has nil as an id
  end

  def ticket_params
    params.require(:ticket).permit :username, :description, :subject
  end
end
