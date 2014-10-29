destroyTab = (context, instance) ->
  allTabs = context.data.options.source.fetch()
  currentSource = _.findWhere(allTabs, {_id: instance._id})
  currentIndex = allTabs.indexOf(currentSource)
  latestLength = context.options.destroyAction(instance)

  if latestLength > 0
    nextIndex = currentIndex + 1
    nextIndex = currentIndex - 1 if currentIndex is latestLength #last tab was deleted
    Session.set(context.options.currentSource, allTabs[nextIndex])
    context.options.navigateAction?(allTabs[nextIndex])
  else if latestLength is 0
    newTab = context.options.createAction()
    Session.set(context.options.currentSource, newTab)
    context.options.navigateAction?(newTab)

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
    "dblclick span.fa": (event, template) ->
      destroyTab(template.data, @); event.stopPropagation()