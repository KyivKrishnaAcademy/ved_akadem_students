#= require intl-tel-input
#= require intl-tel-input/build/js/utils

window.initTelInput = ->
  telInputs = document.querySelectorAll('#nested-telephones input.tel:not(.tel-input)')

  telInputs.forEach (telInput) ->
    iti = intlTelInput(telInput, {
      preferredCountries: ['ua', 'by', 'md']
      separateDialCode: true
    })

    $(telInput).addClass('tel-input')
