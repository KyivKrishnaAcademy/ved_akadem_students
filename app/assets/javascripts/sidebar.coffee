$ ->
  $body = $('body')

  $('#sidebar-toggler').on 'click', (e) ->
    $body.toggleClass 'sidebar-opened'

  $('label .sidebar-icon').on 'click', (e) ->
    $body.addClass 'sidebar-opened'
