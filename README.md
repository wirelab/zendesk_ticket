# Zendesk Ticket

## Installation
Include the gem in your Gemfile

```ruby
gem 'zendesk_ticket'
```

Bundle the Gemfile

```ruby
bundle install
```

## Setup Zendesk

Create an account at zendesk and visit https://YOUR_COMPANY.zendesk.com/agent/#/admin/api

Check 'access with token' and write down the API-token

## Configuring

To generate an intializer and translation files, run

```ruby
rails generate zendesk_ticket:install
```

Add the following to your environment:
* ZENDESK_TOKEN The token you just got from zendesk
* ZENDESK_URL https://YOUR_COMPANY.zendesk.com/

Add to your application.css:
```css
/*
 * require zendesk_ticket.css
 */
```

To your application.js: 
```javascript
//= require zendesk_ticket.js
```

In your html
```
  <%= render "zendesk_ticket/popup" %>
  <%= render "zendesk_ticket/button" %>
```

If you want to use a custom button to call the popup, you can leave out the zendesk_ticket/button partial and add data-zendesk-ticket-button to your button.

## License
This project rocks and uses MIT-LICENSE.
