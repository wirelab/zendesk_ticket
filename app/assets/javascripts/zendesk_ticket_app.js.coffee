class ZendeskTicketApp
  initialize: ->
    @csrf = $('meta[name="csrf-token"]').attr('content')

    @$btn = $('[data-zendesk-ticket-button]')
    @$btn.on 'click', @buttonHandler

    @$login_form = $('[data-zendesk-ticket-form]')
    email = $.cookie 'zendesk_email'   
    
    @$username_input = @$login_form.find('input[name="ticket[username]"]')
    @$username_label = @$login_form.find('label[for="ticket_username"]')
    @$info = $('<p data-zendesk-ticket-username /><br />').html("Ingelogd als #{email}. ")
    @$logout = $('<a href="javascript: ">Bent u dit niet? Log hier dan uit.</a>')
    
    @$info.append @$logout
    @$login_form.on 'click', '[data-zendesk-ticket-username]', =>
      $.removeCookie 'zendesk_email', { path: '/' }
      @toggleUsernameInput()

    @toggleUsernameInput(email)

    @$login_form.on 'submit', @loginFormHandler
    @$slider = $('.zendesk_ticket_slides')
    $('[data-zendesk-ticket-back]').on 'click', =>
      @$slider.animate({marginLeft: 0}, 500)    
    $('[data-zendesk-ticket-close]').on 'click', =>
      $('[data-zendesk-ticket-popup-container]').toggleClass('hidden')
      @$slider.css('margin-left', 0)
      @$login_form.find('[name="ticket[subject]"]').val('')
      @$login_form.find('[name="ticket[description]"]').val('')

  toggleUsernameInput: (email) =>
    if email
      @$username_input.attr('type','hidden')
      @$username_input.val email
      @$login_form.find('[name="ticket[subject]"]').val('')
      @$login_form.find('[name="ticket[description]"]').val('')
      @$username_input.after @$info
      @$username_label.hide()
    else
      @$username_input.attr('type','email')
      @$username_input.val ''
      @$username_label.show()
      @$info.remove()

  buttonHandler: (event) ->
    $('[data-zendesk-ticket-popup-container]').toggleClass('hidden')

  loginFormHandler: (event) =>
    app = this
    event.preventDefault()
    $form = $(event.currentTarget)
    
    description = $form.find('textarea[name="ticket[description]"]').val()
    if description != ""
      description += "\n Extra informatie: \n"
      description += "Pagina: #{window.location.protocol}//#{window.location.host}#{window.location.pathname}#{window.location.port} \n"
      browser = []
      for own attribute, value of bowser
        browser.push "#{attribute}: #{value}" if attribute != "a" or attribute != "b" or attribute != "x"
      description += "Browser: #{browser.join(', ')}"

    data =
      ticket:
        username: $form.find('input[name="ticket[username]"]').val()
        subject: $form.find('input[name="ticket[subject]"]').val()
        description: description

    $.ajax
      url: $form.attr('action')
      data: data
      beforeSend: (xhr) ->  
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      type: 'POST'
      dataType: 'json'
      success: (data) ->
        $.cookie 'zendesk_email', $form.find('input[name="ticket[username]"]').val(), { expires: 30, path: '/' }
        app.toggleUsernameInput($.cookie('zendesk_email'))

        slide_width = $('.zendesk_ticket_slides .slide').width()
        app.$slider.animate({marginLeft: -slide_width}, 500)
        $('[data-zendesk-ticket-url]').html $("<a href='#{data.ticket.url}' target='_blank'>Uw ticket.</a>")

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
