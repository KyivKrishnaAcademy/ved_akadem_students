#= require cookies-js/dist/cookies

Cookies.defaults =
  path: '/'
  expires: (new Date).setYear((new Date).getFullYear() + 1)

openedClass = 'sidebar-is-opened'

switchMenu = (status, $body) ->
  if status
    $body.addClass openedClass

    Cookies.set openedClass, true
  else
    $checkboxes = $('.sidebar-accordion .group-status:checked')

    $body.removeClass openedClass
    $checkboxes.prop 'checked', false

    Cookies.expire openedClass

    $.each $checkboxes, (_, checkbox) -> Cookies.expire(checkbox.id + '-submenu-is-opened')

$ ->
  $body = $('body')

  $('#sidebar-toggler').on 'click', (e) ->
    switchMenu !$body.hasClass(openedClass), $body

  $('label .sidebar-icon').on 'click', (e) ->
    switchMenu true, $body

  $('.sidebar-accordion').on 'change', '.group-status', (e) ->
    openedKey = e.target.id + '-submenu-is-opened'

    if e.target.checked
      Cookies.set openedKey, true
    else
      Cookies.expire openedKey

  $('li a.is-active').parents('.sidebar-accordion ul').siblings('label').addClass('is-active')
