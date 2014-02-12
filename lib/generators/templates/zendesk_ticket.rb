ZendeskTicket.setup do |config|
  config.token = '<%%= ENV['ZENDESK_API_TOKEN'] %>'
  config.url = '<%%= ENV['ZENDESK_URL'] %>'
end
