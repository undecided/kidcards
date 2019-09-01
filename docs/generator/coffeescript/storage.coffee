# Localstorage will not be enough. Once tooling is running again, swap out for filestore seamlessly

class @Storage
  @storage: -> window.localStorage

  @get: (key, fn = ->)-> fn(@storage.getItem(key)
  @put: (key, val, fn = ->)-> fn(val) if @storage.putItem(key, val)

  @getJson: (key, fn = ->)-> @get(key, (val)-> fn(JSON.parse val if val?))
  @putJson: (key, val, fn = ->)> 
    val = JSON.serialize(val)
    @put(key, val, fn)



