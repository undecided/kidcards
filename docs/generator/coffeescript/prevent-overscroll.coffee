# Taken from https://github.com/luster-io/prevent-overscroll/blob/master/index.js
# Copyright (c) 2014 luster-io
# Converted to coffeescript

$ ->
  el = document.body
  el.addEventListener 'touchstart', ->
    top = el.scrollTop
    totalScroll = el.scrollHeight
    currentScroll = top + el.offsetHeight

    # If we're at the top or the bottom of the containers scroll, push up or down
    # one pixel.
    #
    # this prevents the scroll from "passing through" to the body.
    if top is 0
      el.scrollTop = 1
    else if currentScroll is totalScroll
      el.scrollTop = top - 1

  el.addEventListener 'touchmove', (evt) ->
    # if the content is actually scrollable, i.e. the content is long enough
    # that scrolling can occur
    if(el.offsetHeight < el.scrollHeight)
      evt._isScroller = true

  document.body.addEventListener 'touchmove', (evt) ->
    # In this case, the default behavior is scrolling the body, which
    # would result in an overflow.  Since we don't want that, we preventDefault.
    evt.preventDefault() unless evt._isScroller
