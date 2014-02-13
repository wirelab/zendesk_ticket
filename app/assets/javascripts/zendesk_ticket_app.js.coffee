class ZendeskTicketApp
  initialize: ->
    @csrf = $('meta[name="csrf-token"]').attr('content')

    @$btn = $('[data-zendesk-ticket-button]')
    @$btn.on 'click', @buttonHandler

    @$login_form = $('[data-zendesk-ticket-form]')
    email = $.cookie 'zendesk_email'
    @$login_form.find('input[name="ticket[email]"]').val(email) if email
    @$login_form.on 'submit', @loginFormHandler

  buttonHandler: (event) =>
    $('[data-zendesk-ticket-popup-container]').toggleClass('hidden')

  loginFormHandler: (event) ->
    event.preventDefault()
    $form = $(this)

    data =
      ticket:
        username: $form.find('input[name="ticket[username]"]').val()
        subject: $form.find('input[name="ticket[subject]"]').val()
        description: $form.find('textarea[name="ticket[description]"]').val()

    $.ajax
      url: $form.attr('action')
      data: data
      beforeSend: (xhr) ->  
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      type: 'POST'
      dataType: 'json'
      success: ->
        alert 'yeah'
        $.cookie 'zendesk_email', $form.find('input[name="ticket[email]"]')
      error: (xhr, msg) ->
        $form.find('span.error').remove()
        if xhr.responseJSON.errors.base?
          for own attribute, message of xhr.responseJSON.errors.base[0]
            $error = $("<span />").addClass('error').html message
            $form.find("[name='ticket[#{attribute}]']").after $error
        else
          alert 'Unknown error has occured'
$ ->  
  app = new ZendeskTicketApp
  app.initialize()
