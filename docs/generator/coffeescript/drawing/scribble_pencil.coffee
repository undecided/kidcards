class @ScribblePencil
  constructor: (@context)->
    @awaiting_bezier = []
    @awaiting_curve_points = []

  draw_point: (point) ->
    @context.fillStyle = point.colour
    @awaiting_bezier.push(x: point.x, y: point.y)
    @fill_bezier()

  fill_bezier: ->
    p = @awaiting_bezier
    return if p.length < 3
    gap_length = Math.sqrt(Math.pow(p[1].x - p[0].x, 2) + Math.pow(p[1].y - p[0].y, 2))
    gap_length += Math.sqrt(Math.pow(p[2].x - p[1].x, 2) + Math.pow(p[2].y - p[1].y, 2)) if p[2]
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


