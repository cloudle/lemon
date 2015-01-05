lemon.defineWidget Template.iGrid,
  itemTemplate: ->
    template = UI._templateInstance()
    itemTemplate = template.data.options.itemTemplate
    if typeof itemTemplate is 'function' then itemTemplate(@) else itemTemplate
  dataSource: -> UI._templateInstance().data.options.reactiveSourceGetter()
  classicalHeader: -> UI._templateInstance().data.options.classicalHeader