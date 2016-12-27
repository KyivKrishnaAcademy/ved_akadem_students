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
    $checkboxes = $('.sidebar-accordion .group-status:checked')

    $body.removeClass openedClass
    $checkboxes.prop 'checked', false

    Cookies.expire openedKey

    $.each $checkboxes, (_, checkbox) -> Cookies.expire(checkbox.id + '_submenu_opened')

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
