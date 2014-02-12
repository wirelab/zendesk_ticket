require 'rails/generators'

module ZendeskTicket
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Zendesk Ticket initializer and copy locale files to your application."

      def copy_initializer
        template "zendesk_ticket.rb", "config/initializers/zendesk_ticket.rb"
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/zendesk_ticket.en.yml"
        copy_file "../../../config/locales/nl.yml", "config/locales/zendesk_ticket.nl.yml"
      end

    end
  end
end
