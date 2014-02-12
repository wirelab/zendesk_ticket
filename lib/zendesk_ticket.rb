require 'zendesk_api'
module ZendeskTicket
  class Engine < Rails::Engine; end
end

module ZendeskTicket
  mattr_accessor :api_token
  @@api_token = nil  

  mattr_accessor :url
  @@url = nil  

  mattr_accessor :route
  @@route = 'ticket'

  def self.setup
    yield self
  end
end
