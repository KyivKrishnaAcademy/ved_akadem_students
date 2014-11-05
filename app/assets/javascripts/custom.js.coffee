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
