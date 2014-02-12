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

  s.add_dependency "rails", "~> 4.0.0"

  s.add_development_dependency "sqlite3"
end
