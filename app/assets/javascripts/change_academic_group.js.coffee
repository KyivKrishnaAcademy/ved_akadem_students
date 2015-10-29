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
          $ '#academic-group-link'
          .html '<a href="' + resolved.url + '">' + resolved.title + '</a>'

          $ '#change-academic-group li, #change-academic-group li#remove-from-groups'
          .removeClass 'disabled'

          $ '#change-academic-group li a[data-group="' + resolved.id + '"]'
          .closest 'li'
          .addClass 'disabled'

          true
        .always () ->
          button.removeClass 'disabled'

    changeAcademicGroup. on 'click', '#remove-from-groups a', (e) ->
      e.preventDefault()

      if confirm $(@).data('confirmation')
        button.addClass 'disabled'

        $.ajax
          url: '/ui/people/' + personId + '/remove_from_groups'
          type: 'DELETE',
          dataType: 'json'
        .done () ->
          $ '#academic-group-link'
          .html ''

          $ '#change-academic-group li'
          .removeClass 'disabled'

          $ '#change-academic-group li#remove-from-groups'
          .addClass 'disabled'

          true
        .always () ->
          button.removeClass 'disabled'
  true
