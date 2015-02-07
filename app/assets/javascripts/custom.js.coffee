$ ->
  if $('input#datepicker').length
    locale  = $('input#datepicker').data('locale')
    options = { changeYear: true, changeMonth: true, yearRange: '1934:2004' }

    $('input#datepicker').datepicker($.extend({}, $.datepicker.regional[locale], options))

  $('.popover-description, .popover-photo').popover({
    trigger: 'hover',
    placement: 'auto top',
    delay: { show: 600, hide: 0 },
    html: true
  })

  changeAkademGroup = $('#change-akadem-group')

  if changeAkademGroup.length
    personId = changeAkademGroup.data('person')

    changeAkademGroup. on 'click', '#move-to-group', (e)->
      e.preventDefault()

      groupId  = $(this).data('group')

      $.ajax({
        url: '/people/' + personId + '/move_to_group/' + groupId
        type: 'PATCH',
        dataType: 'script'
      })

    changeAkademGroup. on 'click', '#remove-from-groups a', (e)->
      e.preventDefault()

      $.ajax({
        url: '/people/' + personId + '/remove_from_groups'
        type: 'DELETE',
        dataType: 'script'
      })
