class @ScribblePencil
  constructor: (@context)->
    @stop_drawing()
    @last_event = null
    @awaiting_curve_points = []

  stop_drawing: (_event) =>
    @awaiting_bezier = []
    @drawing = false

  start_point: (event) =>
    @drawing = true
    @add_point(event)

  add_point: (event) =>
    return unless @drawing
    return add_point(event.targetTouches[0]) if event.targetTouches?[0]
    return if @should_delay(event)
    @last_event = event
    [x, y] = @relative_xy(event)
    @context.fillStyle = window.paint_colour
    @awaiting_bezier.push(x: x, y: y)
    @fill_bezier()

  relative_xy: (event) =>
    rect = event.target.getBoundingClientRect()
    x = event.pageX - rect.left
    y = event.pageY - rect.top
    if true
        c = ["#CC0000", "#00CC00", "#0000CC", "#00CCCC", "#CC00CC", "#CCCC00"]
        @context.fillStyle = c[Math.floor(Math.random() * c.length)]
        @context.fillRect(x, y, window.paint_size * 2, window.paint_size * 2)
    [x, y]

  should_delay: (event)->
    return false unless event? and @last_event?
    event.timeStamp - @last_event.timeStamp < 20

  fill_bezier: ()->
    p = @awaiting_bezier
    return if p.length < 3
    gap_length = Math.sqrt(Math.pow(p[1].x - p[0].x, 2) + Math.pow(p[1].y - p[0].y, 2))
    gap_length += Math.sqrt(Math.pow(p[2].x - p[1].x, 2) + Math.pow(p[2].y - p[1].y, 2)) if p[2]
    # gap_length *= 1.5
    @awaiting_curve_points.unshift([])
    @draw_curve
      gap_length: gap_length
      x: [p[0].x, p[1].x, p[2]?.x]
      y: [p[0].y, p[1].y, p[2]?.y]
      fn: (x, y)=> @awaiting_curve_points[0].push([x,y])

    @awaiting_bezier.shift()
    @render_curve()

  draw_curve: (attrs)->
    {gap_length, x, y, fn} = attrs
    ((i) =>
      t = i / gap_length
      x_pt = Math.round(
        ((1 - t) * (1 - t) * x[0]) +
        (2 * (1 - t) * t * x[1]) +
        (t * t * x[2])
      )
      y_pt = Math.round(
        ((1 - t) * (1 - t) * y[0]) +
        (2 * (1 - t) * t * y[1]) +
        (t * t * y[2])
      )
      fn(x_pt, y_pt)
    )(i) for i in [0..gap_length]

  render_curve: ->
    @context.fillRect(pair[0], pair[1], window.paint_size, window.paint_size) for pair in @awaiting_curve_points[0]
    @awaiting_curve_points = []
