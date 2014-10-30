@Component = {}
Component.helpers = {}

Component.helpers.arrangeAppLayout = ->
  newHeight = $(window).height() - $("#header").outerHeight() - $("#footer").outerHeight() - 6
  $("#container").css('height', newHeight)

Component.helpers.invokeIfNeccessary = (method, context) -> method.apply(context, arguments) if method

Component.helpers.customBinding = (uiOptions, context) ->
  context.ui = {}
  context.ui[name] = context.find(value) for name, value of uiOptions when typeof value is 'string'

Component.helpers.autoBinding = (context) ->
  context.ui = context.ui ? {}
  bindingElements(context)
  bindingSwitch(context)
  bindingDatePicker(context)
  bindingExtras(context)

#  --------------------------------------------------------------------->>
bindingElements = (context) ->
  for item in context.findAll("input[name]:not([binding])")
    name = $(item).attr('name')
    context.ui[name] = item
    context.ui["$#{name}"] = $(item)

bindingSwitch = (context) ->
  context.switch = {}
  for item in context.findAll("input[binding='switch'][name]")
    context.switch[$(item).attr('name')] = new Switchery(item)

toggleExtra = (name, context, mode) ->
  currentExtra = context.ui.extras[name]
  return if !currentExtra
  if mode then currentExtra.$element.show() else currentExtra.$element.hide()
  Component.helpers.arrangeAppLayout()

bindingDatePicker = (context) ->
  context.datePicker = {}
  for item in context.findAll("[binding='datePicker'][name]")
    $item = $(item)
    name = $item.attr('name')
    options = {}
    options.language = 'vi'
    options.todayHighlight = true if $item.attr('todayHighlight') is true
    $item.datepicker(options)
    context.datePicker["$#{name}"] = $item

bindingExtras = (context) ->
  context.ui.extras = {}
  for extra in context.findAll(".editor-row.extra[name]")
    $extra = $(extra)
    name = $extra.attr('name')
    visible = $extra.attr('visibility') ? false
    $extra.show() if visible
    context.ui.extras[name] = { visibility: visible, $element: $extra }
  context.ui.extras.toggleExtra = (name, mode = true) -> toggleExtra(name, context, mode)

