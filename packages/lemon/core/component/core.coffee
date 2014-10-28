@Component = {}

Component.helpers =
  customBinding: (uiOptions, context) ->
    context.ui = {}
    context.ui[name] = context.find(value) for name, value of uiOptions when typeof value is 'string'

  autoBinding: (context) ->
    context.ui = context.ui ? {}
    bindingElements(context)
    bindingSwitch(context)

  invokeIfNeccessary: (method, context) -> method.apply(context, arguments) if method

  arrangeAppLayout: ->
    newHeight = $(window).height() - $("#header").outerHeight() - $("#footer").outerHeight() - 6
    $("#container").css('height', newHeight)

bindingElements = (context) ->
  for item in context.findAll("input[name]:not([binding])")
    name = $(item).attr('name')
    context.ui[name] = item
    context.ui["$#{name}"] = $(item)

bindingSwitch = (context) ->
  context.switch = {}
  for item in context.findAll("input[binding='switch'][name]")
    context.switch[$(item).attr('name')] = new Switchery(item)