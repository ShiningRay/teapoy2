#= require 'sr'
#= require 'helpers'
window.templates =
  render : (name, data) ->
    data.locals = $.helpers
    templates[name](data)
