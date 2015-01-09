$ ->
  if $('input#datepicker').length
    locale  = $('input#datepicker').data('locale')
    options = { changeYear: true, changeMonth: true, yearRange: '1934:2004' }

    $('input#datepicker').datepicker($.extend({}, $.datepicker.regional[locale], options))

  $('.popover-description').popover({
    trigger: 'hover',
    placement: 'auto top',
    delay: { show: 600, hide: 0 }
  })

  if $('#change-akadem-group').length
    $('#change-akadem-group'). on 'click', '#move-to-group', (e)->
      e.preventDefault()

      person_id = $('#change-akadem-group').data('person')
      group_id  = $(this).data('group')

      if confirm('Are you sure you want change group?')
        $.ajax({
          url: '/people/' + person_id + '/move_to_group/' + group_id
          type: 'PATCH',
          dataType: 'script'
        })
