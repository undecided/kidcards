window.paint_colour = "#F00"
window.paint_size = 3

onload = () ->
  canvas = $('canvas.drawing-canvas')[0]
  return unless canvas
  context = canvas.getContext('2d')
  is_drawing = false
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

  awaiting_bezier = []

  $(".colours span").click (event)->
    window.paint_colour = event.currentTarget.className

  fill_bezier = ()->
    p = awaiting_bezier
    return if p.length < 3
    gap_length = Math.sqrt(Math.pow(p[1].x - p[0].x, 2) + Math.pow(p[1].y - p[0].y, 2))
    gap_length += Math.sqrt(Math.pow(p[2].x - p[1].x, 2) + Math.pow(p[2].y - p[1].y, 2))
    # gap_length *= 1.5
    ((i) =>
      t = i / gap_length
      x = Math.round((1 - t) * (1 - t) * p[0].x + 2 * (1 - t) * t * p[1].x + t * t * p[2].x)
      y = Math.round((1 - t) * (1 - t) * p[0].y + 2 * (1 - t) * t * p[1].y + t * t * p[2].y)
      context.fillRect(x, y, window.paint_size, window.paint_size)
    )(i) for i in [0..gap_length]
    awaiting_bezier.shift()
    # awaiting_bezier.shift() # Not necessary, but avoids under-curves. But I like the sketchiness


  draw_pixel = (event)->
    return draw_pixel(event.targetTouches[0]) if event.targetTouches?[0]
    context.fillStyle = window.paint_colour
    rect = event.target.getBoundingClientRect()
    x = event.pageX - rect.left
    y = event.pageY - rect.top
    context.fillRect(x, y, window.paint_size, window.paint_size)
    awaiting_bezier.push(x: x, y: y)
    fill_bezier()

  start_draw = (event) -> is_drawing = true ; draw_pixel(event)
  continue_draw = (event) -> if is_drawing then draw_pixel(event) else true
  stop_draw = (event) -> is_drawing = false ; awaiting_bezier = []

  canvas.addEventListener('mousedown', start_draw)
  canvas.addEventListener('touchstart', start_draw)
  canvas.addEventListener('mousemove', continue_draw)
  canvas.addEventListener('touchmove', continue_draw)
  document.addEventListener('mouseup', stop_draw)
  document.addEventListener('touchend', stop_draw)

# document.addEventListener('load', onload)
$ onload
$(window).resize ->
  canvas = $('canvas.drawing-canvas')[0]
  return unless canvas
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight
