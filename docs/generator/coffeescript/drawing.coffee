window.paint_colour = "#F00"
window.paint_size = 3

class @Drawing
  constructor: ->
    @canvas = $('canvas.drawing-canvas')[0]
    return unless @canvas
    @finalized_context = @canvas.getContext('2d')
    @pending_context = @canvas.getContext('2d')
    @canvas.width = window.innerWidth
    @canvas.height = window.innerHeight
    @events = []
    @last_event = null
    @pending_pencil = null
    @setupEventListeners()
    @setupControls()

  setupEventListeners: ->
    @canvas.addEventListener('mousedown', @start_point)
    @canvas.addEventListener('touchstart', @start_point)
    @canvas.addEventListener('mousemove', @add_point)
    @canvas.addEventListener('touchmove', @add_point)
    document.addEventListener('mouseup', @stop_drawing)
    document.addEventListener('touchend', @stop_drawing)

  stop_drawing: (_event) =>
    return unless @pending_pencil?
    @pending_context.clearRect(0, 0, @canvas.width, @canvas.height)
    @pending_pencil = null
    
    # Create a new pencil with finalized context and replay all events
    final_pencil = new ScribblePencil(@finalized_context)
    final_pencil.draw_point(event) for event in @events

  start_point: (event) =>
    @pending_pencil = new ScribblePencil(@pending_context)
    @add_point(event)

  add_point: (event) =>
    return unless @pending_pencil?
    return @add_point(event.targetTouches[0]) if event.targetTouches?[0]
    return if @should_delay(event)
    @last_event = event
    [x, y] = @relative_xy(event)
    
    event_data = {
      x: x,
      y: y,
      colour: window.paint_colour
    }
    @events.push(event_data)
    @pending_pencil.draw_point(event_data)

  relative_xy: (event) =>
    rect = event.target.getBoundingClientRect()
    x = event.pageX - rect.left
    y = event.pageY - rect.top
    [x, y]

  should_delay: (event)->
    return false unless event? and @last_event?
    event.timeStamp - @last_event.timeStamp < 20

  setupControls: ->
    $(".colours.closed span").click (event) =>
      $(".colours.closed").removeClass("closed")

    $(".colours span").click (event) =>
      return if $(event.currentTarget).hasClass('selected')
      window.paint_colour = event.currentTarget.className
      $(".sizes span span").css backgroundColor: window.paint_colour
      $('.colours .selected').removeClass('selected')
      $(event.currentTarget).addClass('selected')
      $(".colours").addClass("closed")

    $(".sizes span span").click (event) =>
      window.paint_size = parseInt($(event.currentTarget).parent().data('size'))
      $('.sizes .selected').removeClass('selected')
      $(event.currentTarget).addClass('selected')

onload = ->
  window.drawing = new Drawing()

$ onload

$(window).resize ->
  return unless window.drawing?.canvas
  window.drawing.canvas.width = window.innerWidth
  window.drawing.canvas.height = window.innerHeight
