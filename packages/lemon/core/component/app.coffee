helpers = Component.helpers

exceptions = ['ui', 'rendered']

lemon.defineApp = (source, destination) ->
  source[name] = value for name, value of destination when !_(exceptions).contains(name)

  source.rendered = ->
    helpers.customBinding(destination.ui, @) if destination.ui
    helpers.autoBinding(@)
    helpers.arrangeAppLayout()
    helpers.invokeIfNeccessary(destination.rendered, @)