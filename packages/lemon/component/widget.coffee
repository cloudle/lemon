helpers = Component.helpers

exceptions = ['ui', 'rendered']

lemon.defineWidget = (source, destination) ->
  source[name] = value for name, value of destination when !_(exceptions).contains(name)

  rendered = ->
    helpers.customBinding(destination.ui, @) if destination.ui
    helpers.invokeIfNeccessary(destination.rendered, @)