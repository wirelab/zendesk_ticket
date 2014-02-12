ZendeskTicket.setup do |config|
  config.api_token = ENV['ZENDESK_API_TOKEN']
  config.url = ENV['ZENDESK_URL']
end
