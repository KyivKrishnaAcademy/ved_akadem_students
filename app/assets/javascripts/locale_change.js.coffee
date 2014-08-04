$ ->
  $('.change_locale').click (e)->

    e.preventDefault()

    $.ajax({
      url: '/locales/toggle',
      type: 'GET',
      data: '',
      dataType: 'script'
    })
