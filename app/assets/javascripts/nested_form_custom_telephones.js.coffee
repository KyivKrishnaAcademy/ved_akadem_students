$ ->
  telephonesFieldsCount = $('#nested-telephones #phone').length

  if telephonesFieldsCount
    initTelInput = ->
      telInput = $('#phone:not(.tel-input)')

      telInput.intlTelInput({
        preferredCountries: ["ua", "ru"],
        utilsScript: "assets/libphonenumber/utils.js"
      })

      telInput.addClass('tel-input')

    toggleAddLink = ->
      $('a.add_nested_fields').toggle telephonesFieldsCount < 4
      return

    toggleRemoveLink = ->
      $('a.remove_nested_fields').toggle telephonesFieldsCount != 1
      return

    $(document).on 'nested:fieldAdded', ->
      telephonesFieldsCount += 1
      toggleAddLink()
      toggleRemoveLink()
      initTelInput()
      return

    $(document).on 'nested:fieldRemoved', ->
      telephonesFieldsCount -= 1
      toggleAddLink()
      toggleRemoveLink()
      return

    toggleAddLink()
    toggleRemoveLink()
    initTelInput()
