@Component = {}

Component.helpers =
  customBinding: (uiOptions, context) ->
    context.ui = {}
    context.ui[name] = context.find(value) for name, value of uiOptions when typeof value is 'string'

  autoBinding: (context) ->
    context.ui = context.ui ? {}
    context.ui[$(item).attr('name')] = item for item in context.findAll("input[binding][name]")

  invokeIfNeccessary: (method, context) -> method.apply(context, arguments) if method