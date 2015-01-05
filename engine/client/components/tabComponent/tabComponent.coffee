destroyTab = (context, instance) ->
  options = context.data.options
  allTabs = options.source.fetch()
  currentSource = _.findWhere(allTabs, {_id: instance._id})
  currentIndex = allTabs.indexOf(currentSource)
  latestLength = options.destroyAction?(instance)

  if latestLength > 0
    nextIndex = currentIndex + 1
    nextIndex = currentIndex - 1 if currentIndex is latestLength #last tab was deleted
    Session.set(options.currentSource, allTabs[nextIndex])
    options.navigateAction?(allTabs[nextIndex])
  else if latestLength is 0
    newTab = options.createAction()
    Session.set(options.currentSource, newTab)
    options.navigateAction?(newTab)

generateActiveClass = (context, instance) ->
  key = context.data.options.key
  currentSource = Session.get(context.data.options.currentSource)
  if instance[key] is currentSource?[key] then 'active' else ''

lemon.defineWidget Template.tabComponent,
  activeClass: -> generateActiveClass(UI._templateInstance(), @)
  dynamicCaption: -> @[UI._templateInstance().data.options.caption ? 'caption']

  events:
    "click li:not(.new-button):not(.active)": (event, template) ->
      Session.set(template.data.options.currentSource, @)
      template.data.options.navigateAction?(@)
    "click li.new-button": (event, template) ->
      Session.set(template.data.options.currentSource, template.data.options.createAction())
    "click span.delete-button": (event, template) ->
      destroyTab(template, @); event.stopPropagation()