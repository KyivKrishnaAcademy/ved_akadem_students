$ ->

  if $('#nested-telephones').length
    $addLink = $('a.add_nested_fields')
    fieldsCount = $('form .fields').length

    toggleAddLink = ->
      $addLink.toggle fieldsCount <= 4
      return

    toggleRemoveLink = ->
      $('a.remove_nested_fields').toggle fieldsCount != 1
      return

    $(document).on 'nested:fieldAdded', ->
      fieldsCount += 1
      toggleAddLink()
      toggleRemoveLink()
      return

    $(document).on 'nested:fieldRemoved', ->
      fieldsCount -= 1
      toggleAddLink()
      toggleRemoveLink()
      return

    toggleAddLink()
    toggleRemoveLink()
