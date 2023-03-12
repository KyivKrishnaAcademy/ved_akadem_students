window.adjustAttendanceHeaders = (className, correctionn = 0) ->
  $attendanceHeaders = $(className)
  mapper = (el) -> el.offsetHeight
  sorter = (a, b) -> a - b
  height = $attendanceHeaders.toArray().map(mapper).sort(sorter)[$attendanceHeaders.length - 1]

  if !height
    return

  $attendanceHeaders.height(height + correctionn)

$ ->
  $('.popover-enable').popover({
    trigger: 'hover',
    placement: 'auto top',
    delay: { show: 600, hide: 0 },
    html: true
  })

  $('a[href="#group_attendance"], a[href="#academic_performance"]').on 'shown.bs.tab', () ->
    window.adjustAttendanceHeaders('.scrollable-header')
