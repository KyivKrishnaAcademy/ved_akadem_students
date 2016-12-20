#= require cookies-js/dist/cookies

Cookies.defaults =
  path: '/'

openedClass = 'sidebar-opened'

swithMenu = (status, $body) ->
  expires = new Date
  openedKey = 'sidebar_opened'

  expires.setYear(expires.getYear() + 1)

  if status
    $body.addClass openedClass

    Cookies.set openedKey, true, { expires: expires }
  else
    $body.removeClass openedClass

    Cookies.expire openedKey

$ ->
  $body = $('body')

  $('#sidebar-toggler').on 'click', (e) ->
    swithMenu !$body.hasClass(openedClass), $body

  $('label .sidebar-icon').on 'click', (e) ->
    swithMenu true, $body
