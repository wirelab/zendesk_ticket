require 'zendesk_api'

module ZendeskTicket
  mattr_accessor :api_token
  @@api_token = nil  

  mattr_accessor :url
  @@url = nil

  def self.setup
    yield self
  end
end
