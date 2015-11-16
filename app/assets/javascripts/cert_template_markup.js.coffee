#= require Jcrop/js/Jcrop
#= require jquery-bigtext/jquery-bigtext

$ ->
  new CertTemplateMarkuper()

class CertTemplateMarkuper
  constructor: () ->
    cropper     = @
    markupBox   = $('#markup-box')

    markupBox.Jcrop
      bgColor: 'darkorange'
      bgOpacity: 0.3
      canDelete: false
      minSize: [10, 10]
      multi: true
      multiMax: $('.field-set').length
      () ->
        cropper.ratio = markupBox.data().width / markupBox.width()
        window.jcr    = @ # DEBUG

        cropper.initSelections(@)

        true

  initSelections: (jcrop_api) =>
    cropper = @

    $('.field-set').each () ->
      fieldSet      = $(@)
      dimensions    = cropper.getDimensions fieldSet
      selection     = jcrop_api.newSelection().update($.Jcrop.wrapFromXywh(dimensions))
      fieldSetId    = fieldSet.attr('id')
      selectionBox  = $('.jcrop-current')

      selectionBox.prepend(
        '<span id="' + fieldSetId + '" class="selection-label">' +
        fieldSet.data().label +
        '</span>'
      )

      cropper.adjustLabelSize(selectionBox, fieldSetId)

      selection.element.on 'cropend', () ->
        cropper.adjustLabelSize(selectionBox, fieldSetId)

        true

      cropper.applyCoordsOnMove selection, fieldSet

      true

    true

  getDimensions: (fieldSet) =>
    ratio = @ratio

    $.map(fieldSet.find('input'), (el) ->
      Math.round((Number($(el).val()) || 10) / ratio)
    )

  adjustLabelSize: (parent, id) =>
    label = parent.find('#' + id)

    label.bigText()
    label.css position: 'absolute'

    true

  applyCoordsOnMove: (selection, fieldSet) =>
    xField  = fieldSet.find('#x')
    yField  = fieldSet.find('#y')
    wField  = fieldSet.find('#w')
    hField  = fieldSet.find('#h')
    ratio   = @ratio

    selection.element.on 'cropmove', (event, selection, coords) ->
      xField.val(Math.round(coords.x * ratio))
      yField.val(Math.round(coords.y * ratio))
      wField.val(Math.round(coords.w * ratio))
      hField.val(Math.round(coords.h * ratio))

      true
    true
