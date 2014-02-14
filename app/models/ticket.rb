class Ticket
  attr_accessor :errors

  def initialize params
    @description = params[:description]
    @subject = params[:subject]
    @username = params[:username]
  end

  def save
    if is_client_authenticated?
      ticket = ZendeskAPI::Ticket.new client
      ticket.subject = @subject
      ticket.description = @description
      ticket.submitter_id = client.current_user.id
      if ticket.save
        @zendesk_ticket = ticket
        true
      else
        @errors = ticket.errors
        false
      end
    else
      @errors = { base: [ username: I18n.t('unauthorized', scope: 'zendesk_ticket.user.errors') ] }
      false
    end
  end

  def url
    if @zendesk_ticket.present? && @zendesk_ticket.id?
      base_url = URI::join(ZendeskTicket.url, '/').to_s
      "#{base_url}tickets/#{@zendesk_ticket.id}"
    end
  end

  private
  def client
    ZendeskAPI::Client.new do |config|
      config.url = ZendeskTicket.url
      config.username = @username
      config.token = ZendeskTicket.api_token
    end
  end

  def is_client_authenticated?
    client.current_user.id.present? # an invalid user still returns an user object, but has nil as an id
  end
end
