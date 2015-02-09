simpleFormatRE1 = /\r\n?/g
simpleFormatRE2 = /\n\n+/g
simpleFormatRE3 = /([^\n]\n)(?=[^\n])/g

$.helpers = {}

$.helpers.simple_format = (str) ->
  fstr = str
  fstr = fstr.replace(simpleFormatRE1, "\n"
  ).replace(simpleFormatRE2, "</p>\n\n<p>"
  ).replace(simpleFormatRE3, "$1<br/>")
  fstr = "<p>" + fstr + "</p>"
  fstr

autoLinkReg = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/g

$.helpers.auto_link = (text) ->
  text.replace autoLinkReg, "<a href='$1' rel='external' target='_blank'>$1</a>"
  
Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output
$.helpers.escape = (unsafe) ->
  unsafe.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace /'/g, "&#039;"

