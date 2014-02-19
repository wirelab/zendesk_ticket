class ZendeskTicketApp
  constructor: ->
    @events = $({})
  initialize: =>
    popup = new ZendeskTicketApp.Popup @events
    button = new ZendeskTicketApp.SidebarButton @events
    slider = new ZendeskTicketApp.Slider @events
    form = new ZendeskTicketApp.Form @events
    session = new ZendeskTicketApp.Session @events

    #login if session exists
    email = $.cookie 'zendesk_email'
    @events.trigger 'login:session', email if email

class ZendeskTicketApp.Base
  constructor: (@events, options = {}) ->
    @$el = $(@el) if @el?
    @initialize(options)
  initialize: ->
    throw "initialize not implemented"

# Button on the side, opening the popup
class ZendeskTicketApp.SidebarButton extends ZendeskTicketApp.Base
  el: '[data-zendesk-ticket-button]'
  initialize: ->
    @$el.on 'click', @buttonHandler
  buttonHandler: (event) =>
    @events.trigger 'toggle:popup'

# The lightbox popup holding the form
class ZendeskTicketApp.Popup extends ZendeskTicketApp.Base
  el: '[data-zendesk-ticket-popup-container]'
  initialize: =>
    @$el.find('[data-zendesk-ticket-close]').on 'click', => @events.trigger "close:popup"

    @events.on 'toggle:popup', @toggle
    @events.on 'open:popup', @open
    @events.on 'close:popup', @close
  toggle: =>
    @$el.toggleClass('hidden')
  open: =>
    @$el.removeClass('hidden')
  close: =>
    @$el.addClass('hidden')

# Slider, going back and forwards between form and thankyou page
class ZendeskTicketApp.Slider extends ZendeskTicketApp.Base
  el: '[data-zendesk-ticket-slider]'
  initialize: =>
    @slide_width = @$el.find('.slide').width()

    $('[data-zendesk-ticket-back]').on 'click', @back
    $('[data-zendesk-ticket-forward]').on 'click', @forward

    @events.on 'back:slider', @back
    @events.on 'close:popup', @back
    @events.on 'forward:slider', @forward
  forward: =>
    @$el.animate({marginLeft: -@slide_width}, 500)
  back: =>
    @$el.animate({marginLeft: 0}, 500)

# Form to create a ticket
class ZendeskTicketApp.Form extends ZendeskTicketApp.Base
  el: '[data-zendesk-ticket-form]'
  initialize: ->
    @csrf = $('meta[name="csrf-token"]').attr('content')

    @$el.on 'submit', @submitHandler
    @events.on 'login:session', @hideUserNameInput
    @events.on 'logout:session', @showUserNameInput
    @events.on 'close:popup', @reset

  hideUserNameInput: (event, username) =>
    $form = @$el
    $username_input = $form.find('input[name="ticket[username]"]')
    $username_label = $form.find('label[for="ticket_username"]')

    # make username an hidden input field
    $username_input.attr('type','hidden')
    $username_input.val username

    # reset fields
    $form.find('[name="ticket[subject]"]').val('')
    $form.find('[name="ticket[description]"]').val('')

    # add login info and logout button
    $username_input.after @createLogoutButton(username)

    # hide label
    $username_label.hide()

  showUserNameInput: (event, username) =>
    $form = @$el
    $username_input = $form.find('input[name="ticket[username]"]')
    $username_label = $form.find('label[for="ticket_username"]')

    # set username input back to an email input
    $username_input.attr('type','email')

    # reset username input
    $username_input.val ''

    # show labal
    $username_label.show()

    $form.find('[data-zendesk-ticket-username]').remove()

  createLogoutButton: (email) =>
    $info = $('[data-zendesk-ticket-username]')
    if $info.length == 0
      $info = $('<p data-zendesk-ticket-username /><br />').html("<span>Ingelogd als #{email}.</span>")
      $logout = $('<a href="javascript: ">Bent u dit niet? Log hier dan uit.</a>')
      $logout.on 'click', =>
        @events.trigger 'logout:session', email
      $info.append $logout
    else
      $info.find('span').html "Ingelogd als #{email}."
    $info

  appendMetadataToDescription: (description) ->
    if description != ""
      description += "\n Extra informatie: \n"
      description += "Pagina: #{window.location.protocol}//#{window.location.host}#{window.location.pathname}#{window.location.port} \n"
      browser = []
      for own attribute, value of bowser
        browser.push "#{attribute}: #{value}" if attribute != "a" or attribute != "b" or attribute != "x"
      description += "Browser: #{browser.join(', ')}"
    description

  submitHandler: (event) =>
    app = this
    event.preventDefault()
    $form = $(event.currentTarget)
    events = @events

    data =
      ticket:
        username: $form.find('input[name="ticket[username]"]').val()
        subject: $form.find('input[name="ticket[subject]"]').val()
        description: @appendMetadataToDescription $form.find('textarea[name="ticket[description]"]').val()

    post = $.ajax
      url: $form.attr('action')
      data: data
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-Token', @csrf
      type: 'POST'
      dataType: 'json'

    post.done (data) ->
      events.trigger "login:session", $form.find('input[name="ticket[username]"]').val()
      events.trigger "forward:slider"
      # reset errors
      $form.find('span.error').remove()
      # display ticket url
      $('[data-zendesk-ticket-url]').html $("<a href='#{data.ticket.url}' target='_blank'>Uw ticket.</a>")

    post.fail (xhr, data) ->
      $form.find('span.error').remove()
      if xhr.responseJSON.errors.base?
        for own attribute, message of xhr.responseJSON.errors.base[0]
          $error = $("<span />").addClass('error').html message
          $form.find("[name='ticket[#{attribute}]']").after $error
      else
        alert 'Unknown error has occured'

  reset: =>
    @$el.find('input[name="ticket[subject]"]').val('')
    @$el.find('textarea[name="ticket[description]"]').val('')

# Holds the user session
class ZendeskTicketApp.Session extends ZendeskTicketApp.Base
  initialize: ->
    @events.on 'login:session', (event, username) =>
      @set username
    @events.on 'logout:session', @destroy
  email: ->
    $.cookie 'zendesk_email'
  set: (username) ->
    $.cookie 'zendesk_email', username, { expires: 30, path: '/' }
    $.cookie 'zendesk_email'
  destroy: ->
    $.removeCookie 'zendesk_email', { path: '/' }

window.ZendeskTicketApp = ZendeskTicketApp

$ ->
  app = new ZendeskTicketApp
  app.initialize()

