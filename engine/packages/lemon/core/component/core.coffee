@Component = {}
Component.helpers = {}

Component.helpers.arrangeAppLayout = ->
  $(".nano").nanoScroller()
  newHeight = $(window).height() - $("#header").outerHeight() - $("#footer").outerHeight()
  $("#container").css('height', newHeight)

Component.helpers.invokeIfNeccessary = (method, context) -> method.apply(context, arguments) if method

Component.helpers.customBinding = (uiOptions, context) ->
  context.ui = {}
  context.ui[name] = context.find(value) for name, value of uiOptions when typeof value is 'string'

Component.helpers.bindingElements = (context) -> bindingElements(context)
Component.helpers.bindingHotkeys = (context) -> bindingHotkeys(context)

Component.helpers.autoBinding = (context) ->
  context.ui = context.ui ? {}
  bindingToolTip(context)
  bindingElements(context)
  bindingSwitch(context)
  bindingDatePicker(context)
  bindingExtras(context)

#  --------------------------------------------------------------------->>
bindingToolTip = (context) ->
  $("[data-toggle='tooltip']").tooltip({container: 'body'})

bindingElements = (context) ->
  for item in context.findAll("input[name]:not([binding])")
    name = $(item).attr('name')
    context.ui[name] = item
    context.ui["$#{name}"] = $(item)

bindingHotkeys = (hotkeyOptions, context) ->
#  context.hotkeys = hotkeyOptions
#  for name, value of hotkeyOptions when typeof value is 'function'


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
    options.autoclose = true
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

