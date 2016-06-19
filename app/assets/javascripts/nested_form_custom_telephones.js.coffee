#= require initTelInput

toggleAddLink = (telephonesFieldsCount) ->
  $('a.add_nested_fields').toggle telephonesFieldsCount < 4

toggleRemoveLink = (telephonesFieldsCount) ->
  $('a.remove_nested_fields').toggle telephonesFieldsCount != 1

$ ->
  telephonesFieldsCount = $('#nested-telephones #phone').length

  if telephonesFieldsCount
    $(document).on 'nested:fieldAdded', ->
      telephonesFieldsCount += 1
      toggleAddLink(telephonesFieldsCount)
      toggleRemoveLink(telephonesFieldsCount)
      window.initTelInput()

    $(document).on 'nested:fieldRemoved', ->
      telephonesFieldsCount -= 1
      toggleAddLink(telephonesFieldsCount)
      toggleRemoveLink(telephonesFieldsCount)

    toggleAddLink(telephonesFieldsCount)
    toggleRemoveLink(telephonesFieldsCount)
    window.initTelInput()
