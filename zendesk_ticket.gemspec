$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "zendesk_ticket/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "zendesk_ticket"
  s.version     = ZendeskTicket::VERSION
  s.authors     = ["Andre Kramer"]
  s.email       = ["andre@wirelab.nl"]
  s.homepage    = "http://www.wirelab.nl"
  s.summary     = "Summary of ZendeskTicket."
  s.description = "Description of ZendeskTicket."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency 'bundler', '>= 1.1'
  s.add_dependency "jquery-rails", ">= 2.0"
  s.add_dependency "jquery-cookie-rails"
  s.add_dependency 'zendesk_api'
end
