#= require cookies-js/dist/cookies

Cookies.defaults =
  path: '/'
  expires: (new Date).setYear((new Date).getFullYear() + 1)

openedClass = 'sidebar-opened'

switchMenu = (status, $body) ->
  openedKey = 'sidebar_opened'

  if status
    $body.addClass openedClass

    Cookies.set openedKey, true
  else
    $body.removeClass openedClass

    Cookies.expire openedKey

$ ->
  $body = $('body')

  $('#sidebar-toggler').on 'click', (e) ->
    switchMenu !$body.hasClass(openedClass), $body

  $('label .sidebar-icon').on 'click', (e) ->
    switchMenu true, $body

  $('.sidebar-accordion').on 'change', '.group-status', (e) ->
    openedKey = e.target.id + '_submenu_opened'

    if e.target.checked
      Cookies.set openedKey, true
    else
      Cookies.expire openedKey
