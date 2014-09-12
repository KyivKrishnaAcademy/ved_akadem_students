$ ->
  telephonesFieldsCount = $('#nested-telephones .fields').length

  if telephonesFieldsCount
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
      return

    $(document).on 'nested:fieldRemoved', ->
      telephonesFieldsCount -= 1
      toggleAddLink()
      toggleRemoveLink()
      return

    toggleAddLink()
    toggleRemoveLink()
