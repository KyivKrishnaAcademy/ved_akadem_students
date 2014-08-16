jQuery ->
  new ImageCropper(150, 200, .75)

class ImageCropper
  constructor: (@width, @height, @aspectRatio) ->
    $('#cropbox').Jcrop
      aspectRatio: @aspectRatio
      minSize: [@width, @height]
      setSelect: [0, 0, @width, @height]
      onSelect: @update
      onChange: @update

  update: (coords) =>
    $('#person_crop_x').val(coords.x)
    $('#person_crop_y').val(coords.y)
    $('#person_crop_w').val(coords.w)
    $('#person_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#preview').css
      width: Math.round(@width/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(@height/coords.h * $('#cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(@width/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(@height/coords.h * coords.y) + 'px'
