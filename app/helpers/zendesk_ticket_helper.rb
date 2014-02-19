module ZendeskTicketHelper
  def zendesk_ticket_translation_json
    translations = I18n.backend.send(:translations).with_indifferent_access
    #raise I18n.backend.send(:translations).with_indifferent_access[I18n.locale].to_yaml
    if translations[I18n.locale][:zendesk_ticket].present?
      translations = translations[I18n.locale][:zendesk_ticket]
    else
      raise "Zendesk translations not found for locale: #{I18n.locale}. Please run rails generator zendesk_ticket:install or add the missing translations manually"
    end
    translations.to_json.html_safe
  end
end
