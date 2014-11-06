formatRoleSelect = (item) -> "#{item.name}" if item

Apps.Merchant.staffManagerInit.push (scope) ->
  Session.set('currentRoleSelection', [])

  logics.staffManager.roleSelectOptions =
    query: (query) -> query.callback
      results: Schema.roles.find().fetch()
    initSelection: (element, callback) -> callback Session.get('currentRoleSelection')
    changeAction: (e) ->
      currentRoles = Session.get('currentRoleSelection')
      currentRoles = currentRoles ? []

      currentRoles.push e.added if e.added
      if e.removed
        removedItem = _.findWhere(currentRoles, {_id: e.removed._id})
        currentRoles.splice currentRoles.indexOf(removedItem), 1

      Session.set('currentRoleSelection', currentRoles)
    reactiveValueGetter: -> Session.get('currentRoleSelection')
    formatSelection: formatRoleSelect
    formatResult: formatRoleSelect
    others:
      multiple: true
      maximumSelectionSize: 3