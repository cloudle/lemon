formatBranchSelect = (item) -> "#{item.name}" if item
formatRoleSelect = (item) -> "#{item.name}" if item
formatWarehouseSelect = (item) -> "#{item.name}" if item
formatGender = (item) -> "#{item.display}" if item

Apps.Merchant.staffManagementInit.push (scope) ->
  scope.branchSelectOptions =
    query: (query) -> query.callback
      results: Schema.merchants.find().fetch()
    initSelection: (element, callback) ->
      callback(Schema.merchants.findOne(Session.get("staffManagementCurrentStaff")?.currentMerchant) ? 'skyReset')
    reactiveValueGetter: -> Session.get("staffManagementCurrentStaff")?.currentMerchant ? 'skyReset'
    changeAction: (e) ->
      option =
        currentMerchant : e.added._id
        currentWarehouse: Schema.warehouses.findOne({merchant: e.added._id, isRoot: true})?._id ? 'skyReset'
      Schema.userProfiles.update Session.get("staffManagementCurrentStaff")?._id, $set: option

      scope.availableWarehouses = Schema.warehouses.find({merchant: e.added._id})

    minimumResultsForSearch: -1
    formatSelection: formatBranchSelect
    formatResult: formatBranchSelect



  scope.roleSelectOptions =
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
      Schema.userProfiles.update Session.get("staffManagementCurrentStaff")._id, $set: {roles: _.pluck(currentRoles, '_id')}
    reactiveValueGetter: -> Session.get('currentRoleSelection')
    formatSelection: formatRoleSelect
    formatResult: formatRoleSelect
    others:
      multiple: true
      maximumSelectionSize: 3


  scope.warehouseSelectOptions =
    query: (query) -> query.callback
      results: Schema.warehouses.find({merchant: Session.get("staffManagementCurrentStaff")?.currentMerchant}).fetch()
    initSelection: (element, callback) ->
      callback(Schema.warehouses.findOne(Session.get("staffManagementCurrentStaff")?.currentWarehouse) ? 'skyReset')
    changeAction: (e) ->
      Schema.userProfiles.update Session.get("staffManagementCurrentStaff")?._id, $set:{currentWarehouse: e.added._id}
    reactiveValueGetter: -> Session.get("staffManagementCurrentStaff")?._id ? 'skyReset'
    minimumResultsForSearch: -1
    formatSelection: formatWarehouseSelect
    formatResult:    formatWarehouseSelect

  scope.genderSelectOptions =
    query: (query) -> query.callback
      results: Apps.Merchant.GenderTypes
      text: 'id'
    initSelection: (element, callback) ->
      callback _.findWhere(Apps.Merchant.GenderTypes, {_id: Session.get("staffManagementCurrentStaff")?.gender})
    reactiveValueGetter: -> _.findWhere(Apps.Merchant.GenderTypes, {_id: Session.get("staffManagementCurrentStaff")?.gender})
    changeAction: (e) ->
      Schema.userProfiles.update Session.get("staffManagementCurrentStaff")._id, $set: {gender: e.added._id}

    formatSelection: formatGender
    formatResult: formatGender
    placeholder: 'CHỌN GIỚI TÍNH'
    minimumResultsForSearch: -1