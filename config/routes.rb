Rails.application.routes.draw do

  scope module: :zendesk_ticket do
    post ZendeskTicket.route => 'tickets#create', as: 'zendesk_ticket'
  end

  

end
