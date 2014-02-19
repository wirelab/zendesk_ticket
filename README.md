# Zendesk Ticket

A widget to send tickets to your companies zendesk. No OAuth, login once and send additional metadata in the ticket like the user agent, url and resolution.

Use this on for instance an acceptance server. A client (which you registered) can leave feedback without letting him go through the trouble of authenticating with oauth. The developer doesn't have to register a new app or app domain, he only have to set up zendesk and the token once.

Because you use the api token to authenticate the user, there is a minor security issue, where client of product A could leave feedback on product B if he knows the acceptance url of product B.

## Installation
Include the gem in your Gemfile

```ruby
gem 'zendesk_ticket', git: 'https://github.com/wirelab/zendesk_ticket.git'
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
 * require zendesk_ticket
 */
```

To your application.js:
```javascript
//= require zendesk_ticket
```

In your html
```
  <%= render "zendesk_ticket/popup" %>
  <%= render "zendesk_ticket/button" %>
```

If you want to use a custom button to call the popup, you can leave out the zendesk_ticket/button partial and add data-zendesk-ticket-button to your button.

Optional:

Instead of posting the form your app, you can post it to a remote website (if you for instance want a centralized server for handeling the data). If this is the case, set the following ENV variable:

* ZENDESK_REMOTE_FORM_URL 'https://YOUR_COMPANY.com/'

Make sure you set up the CORS right. In a future milestone, I'll look into JSONP, making the CORS not needed.

## License
This project rocks and uses MIT-LICENSE.
