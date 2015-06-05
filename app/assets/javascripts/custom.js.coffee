$ ->
  if $('input#datepicker').length
    locale  = $('input#datepicker').data('locale')
    options = { changeYear: true, changeMonth: true, yearRange: '1934:2004' }

    $('input#datepicker').datepicker($.extend({}, $.datepicker.regional[locale], options))

  dateTimePicker = $('input#date-time-picker')

  if dateTimePicker.length
    dateTimePicker.datetimepicker
      locale: dateTimePicker.data('locale')
      sideBySide: true
      widgetPositioning:
        horizontal: 'left'
      stepping: 5

  $('.popover-description, .popover-photo').popover({
    trigger: 'hover',
    placement: 'auto top',
    delay: { show: 600, hide: 0 },
    html: true
  })

  changeAcademicGroup = $('#change-academic-group')

  if changeAcademicGroup.length
    personId = changeAcademicGroup.data('person')

    changeAcademicGroup. on 'click', '#move-to-group', (e)->
      e.preventDefault()

      groupId  = $(this).data('group')

      $.ajax({
        url: '/people/' + personId + '/move_to_group/' + groupId
        type: 'PATCH',
        dataType: 'script'
      })

    changeAcademicGroup. on 'click', '#remove-from-groups a', (e)->
      e.preventDefault()

      $.ajax({
        url: '/people/' + personId + '/remove_from_groups'
        type: 'DELETE',
        dataType: 'script'
      })
