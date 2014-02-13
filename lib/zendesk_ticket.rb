require 'zendesk_api'

module ZendeskTicket
  module Rails
    class Engine < ::Rails::Engine
      initializer :assets, :group => :all do
        ::Rails.application.config.assets.precompile += %w( zendesk_ticket.css zendesk_ticket.js)
      end
    end
  end
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
