formatAreaSelect = (item) -> "#{item.name}" if item

Apps.Merchant.customerManagerInit.push (scope) ->
  Session.set('currentCustomerAreaSelection', [])

#  logics.customerManager.areaSelectOptions =
#    query: (query) -> query.callback
#      results: Schema.roles.find().fetch()
#    initSelection: (element, callback) -> callback Session.get('currentCustomerAreaSelection')
#    changeAction: (e) ->
#      currentAreas = Session.get('currentCustomerAreaSelection')
#      currentAreas = currentAreas ? []
#
#      currentAreas.push e.added if e.added
#      if e.removed
#        removedItem = _.findWhere(currentAreas, {_id: e.removed._id})
#        currentAreas.splice currentAreas.indexOf(removedItem), 1
#
#      Session.set('currentCustomerAreaSelection', currentAreas)
#    reactiveValueGetter: -> Session.get('currentCustomerAreaSelection')
#    formatSelection: formatAreaSelect
#    formatResult: formatAreaSelect
#    others:
#      multiple: true
#      maximumSelectionSize: 3