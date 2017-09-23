$ ->
  changeAcademicGroup = $ '#change-academic-group'

  if changeAcademicGroup.length
    personId  = changeAcademicGroup.data 'person'
    button    = changeAcademicGroup.find('button')

    changeAcademicGroup. on 'click', '#move-to-group', (e) ->
      e.preventDefault()

      groupId  = $(@).data 'group'

      if confirm $(@).data('confirmation')
        button.addClass 'disabled'

        $.ajax
          url: '/ui/people/' + personId + '/move_to_group/' + groupId
          type: 'PATCH',
          dataType: 'json'
        .done (resolved) ->
          $ '#change-academic-group li a[data-group="' + resolved.id + '"]'
          .closest 'li'
          .addClass 'disabled'

          location.reload()
          true
        .always () ->
          button.removeClass 'disabled'
  true
