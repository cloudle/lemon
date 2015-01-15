logics.geraProductGroup = {}
Apps.Gera.geraProductGroupInit = []
Apps.Gera.geraProductGroupReactive = []

Apps.Gera.geraProductGroupReactive.push (scope) ->
  if productGroupId = Session.get("mySession")?.currentGeraProductGroupSelection
    Session.set('geraProductGroupCurrentProductGroup', Schema.productGroups.findOne {_id: productGroupId, buildIn: true})