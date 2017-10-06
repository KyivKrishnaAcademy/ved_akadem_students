window.adjustAttendanceHeaders = ->
  $attendanceHeaders = $('.attendance-header')
  height = $attendanceHeaders.toArray().map((el) -> el.offsetHeight).sort()[$attendanceHeaders.length - 1]

  if !height
    return

  $('.people-header').height(height)
  $attendanceHeaders.height(height)

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

  $('a[href="#group_attendance"]').on 'shown.bs.tab', () ->
    window.adjustAttendanceHeaders()
