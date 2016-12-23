#= require cookies-js/dist/cookies

Cookies.defaults =
  path: '/'

openedClass = 'sidebar-opened'

switchMenu = (status, $body) ->
  expires = new Date
  openedKey = 'sidebar_opened'

  expires.setYear(expires.getFullYear() + 1)

  if status
    $body.addClass openedClass

    Cookies.set openedKey, true, { expires: expires }
  else
    $body.removeClass openedClass

    Cookies.expire openedKey

$ ->
  $body = $('body')

  $('#sidebar-toggler').on 'click', (e) ->
    switchMenu !$body.hasClass(openedClass), $body

  $('label .sidebar-icon').on 'click', (e) ->
    switchMenu true, $body
