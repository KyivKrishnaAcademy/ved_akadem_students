window.initTelInput = ->
  telInput = $('#phone:not(.tel-input)')

  telInput.intlTelInput({
    preferredCountries: ['ua', 'ru'],
    utilsScript: '/assets/libphonenumber/utils.js'
  })

  telInput.addClass('tel-input')
