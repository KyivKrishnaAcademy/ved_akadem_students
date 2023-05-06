#= require initTelInput
#= require cocoon

toggleAddLink = (telephonesFieldsCount) ->
  $('#nested-telephones-add a.add_fields').toggle telephonesFieldsCount < 4

toggleRemoveLink = (telephonesFieldsCount) ->
  $('#nested-telephones a.remove_fields').toggle telephonesFieldsCount != 1

$ ->
  telephonesFieldsCount = $('#nested-telephones .nested-fields').length

  if telephonesFieldsCount
    $('#nested-telephones').on 'cocoon:after-insert', ->
      telephonesFieldsCount += 1
      toggleAddLink(telephonesFieldsCount)
      toggleRemoveLink(telephonesFieldsCount)
      window.initTelInput()

    $('#nested-telephones').on 'cocoon:after-remove', ->
      telephonesFieldsCount -= 1
      toggleAddLink(telephonesFieldsCount)
      toggleRemoveLink(telephonesFieldsCount)

    toggleAddLink(telephonesFieldsCount)
    toggleRemoveLink(telephonesFieldsCount)
    window.initTelInput()
