registerSelection = ($element, context) ->
  selectOptions = {}
  options = context.data.options
  selectOptions.query           = options.query
  selectOptions.formatSelection = (item) -> options.formatSelection(item)
  selectOptions.formatResult    = (item) -> options.formatResult(item)
  selectOptions.initSelection   = options.initSelection
  selectOptions.id              = options.id ? '_id'
  selectOptions.placeholder     = options.placeholder if options.placeholder
  selectOptions.minimumResultsForSearch = options.minimumResultsForSearch if options.minimumResultsForSearch
  _.extend(selectOptions, context.data.options.others) if context.data.options.others

  $element.select2(selectOptions).on 'change', (e) -> options.changeAction(e)

registerHotkey = ($element, context) ->
  if context.data.options.hotkey
    $(document).bind 'keyup', context.data.options.hotkey, -> $element.select2 'open'

startTrackingValue = ($element, context) ->
  context.valueTracker = Tracker.autorun -> setSelection($element, context)

setSelection = ($element, context) ->
  val = context.data.options.reactiveValueGetter()
  if val is 'skyReset'
    $element.select2('val', '')
  else
    $element.select2('val', val) if val

destroySelection = ($element, context) -> $element.select2('destroy')
stopTrackingValue = (context) -> context.valueTracker.stop()

lemon.defineWidget Template.iSelect,
  ui:
    component: ".select2component"
  rendered: ->
    $element = $(@ui.component)
    $element.css('width', @data.width) if @data.width
    $element.addClass(@data.class) if @data.class

    registerSelection $element, @
    registerHotkey $element, @
    startTrackingValue $element, @
    setSelection $element, @

  destroyed: ->
    $element = $(@ui.component)

    destroySelection $element, @
    stopTrackingValue @