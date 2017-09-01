$ ->
  menu_items = $('a.forward')
  return if menu_items.length is 0

  menu_items.click (event)->
    # do some kind of transition
    self = $(event.currentTarget)
    $(self.data('hide')).hide()
    classname = self.data('name')
    $(".#{classname}").show()
