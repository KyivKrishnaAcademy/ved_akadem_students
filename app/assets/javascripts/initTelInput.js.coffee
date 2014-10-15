#= require intlTelInput
#= require libphonenumber/utils

window.initTelInput = ->
  telInput = $('#phone:not(.tel-input)')

  telInput.intlTelInput({
    preferredCountries: ['ua', 'ru']
  })

  telInput.addClass('tel-input')
