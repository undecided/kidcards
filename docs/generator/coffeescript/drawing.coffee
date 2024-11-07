window.paint_colour = "#F00"
window.paint_size = 3

onload = () ->
  canvas = $('canvas.drawing-canvas')[0]
  return unless canvas
  context = canvas.getContext('2d')
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
  # current_pencil = new ScribblePencil(context)
  current_pencil = new SmoothPencil(context)

  $(".colours.closed span").click (event)->
    $(".colours.closed").removeClass("closed")

  $(".colours span").click (event)->
    return if $(event.currentTarget).hasClass('selected')
    window.paint_colour = event.currentTarget.className
    $(".sizes span span").css backgroundColor: window.paint_colour
    $('.colours .selected').removeClass('selected')
    $(event.currentTarget).addClass('selected')
    $(".colours").addClass("closed")

  $(".sizes span span").click (event)->
    window.paint_size = parseInt($(event.currentTarget).parent().data('size'))
    $('.sizes .selected').removeClass('selected')
    $(event.currentTarget).addClass('selected')

  canvas.addEventListener('mousedown', current_pencil.start_point)
  canvas.addEventListener('touchstart', current_pencil.start_point)
  canvas.addEventListener('mousemove', current_pencil.add_point)
  canvas.addEventListener('touchmove', current_pencil.add_point)
  document.addEventListener('mouseup', current_pencil.stop_drawing)
  document.addEventListener('touchend', current_pencil.stop_drawing)

$ onload
$(window).resize ->
  canvas = $('canvas.drawing-canvas')[0]
  return unless canvas
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
