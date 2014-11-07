lemon.defineWidget Template.gridComponent,
  itemTemplate: ->
    template = UI._templateInstance()
    itemTemplate = template.data.options.itemTemplate
    if typeof itemTemplate is 'function' then itemTemplate(@) else itemTemplate
  dataSource: -> @dataSource ? UI._templateInstance().data.options.reactiveSourceGetter()
  classicalHeader: -> UI._templateInstance().data.options.classicalHeader
  animationClass: ->
    animate = UI._templateInstance().data.animation
    if animate then "animated #{animate}" else ''