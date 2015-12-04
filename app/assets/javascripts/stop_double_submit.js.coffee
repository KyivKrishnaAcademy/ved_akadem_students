$ ->
  stop_double_submit = $('.stop_double_submit')

  if stop_double_submit.length
    stop_double_submit. on 'submit', 'form', (e) ->
      buttons = stop_double_submit.find('.btn-submit')

      buttons.prop('disabled', true)
      buttons.addClass('active')

      true
