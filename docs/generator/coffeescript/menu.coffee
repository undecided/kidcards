$ ->
  menu_items = $('ul.menu a')
  return if menu_items.length is 0

  menu_items.click (event)->
    # do some kind of transition
    $(event.currentTarget).parents('.menu').hide()
    classname = $(event.currentTarget).data('name')
    $(".#{classname}").show()
