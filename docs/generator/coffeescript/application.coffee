
$ ->
  if window.cordova? && cordova.file?.documentsDirectory
    alert cordova.file.documentsDirectory
