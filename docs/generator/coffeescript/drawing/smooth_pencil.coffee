class @SmoothPencil extends ScribblePencil

  # should_delay: (event)-> false

  # render_curve: ->
  #   return if @awaiting_curve_points.length < 2
  #   @context.fillRect(pair[0], pair[1], window.paint_size, window.paint_size) for pair in @awaiting_curve_points[0]
  #   @awaiting_curve_points = []
