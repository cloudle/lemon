logics.staffManager = {}
Apps.Merchant.staffManagerInit = []
Apps.Merchant.staffManagerReactiveRun = []


Apps.Merchant.staffManagerInit.push (scope) ->
  scope.availableMerchants = Schema.merchants.find({
    $or:[
      {_id   : Session.get('myProfile').parentMerchant}
      {parent: Session.get('myProfile').parentMerchant}]
  })

  Session.setDefault("createStaffGenderSelection", false)
  Session.setDefault('allowCreateStaffAccount', false)
  Session.setDefault('currentRoleSelection', [])

Apps.Merchant.staffManagerReactiveRun.push (scope) ->
  if Session.get('mySession') and Session.get('myProfile')
    if scope.currentMerchant = Schema.merchants.findOne(Session.get('mySession').createStaffBranchSelection)
      scope.currentWarehouse = Schema.warehouses.findOne({_id: Session.get('mySession').createStaffWarehouseSelection, merchant: scope.currentMerchant._id})
      if !scope.currentWarehouse
        scope.currentWarehouse = Schema.warehouses.findOne({isRoot: true, merchant: scope.currentMerchant._id})
        UserSession.set('createStaffWarehouseSelection', scope.currentWarehouse?._id ? 'skyReset')
    else
      scope.currentMerchant  = Schema.merchants.findOne(Session.get('myProfile').currentMerchant)
      scope.currentWarehouse = Schema.warehouses.findOne(Session.get('myProfile').currentWarehouse)
      UserSession.set('createStaffBranchSelection', Session.get('myProfile').currentMerchant)
      UserSession.set('createStaffWarehouseSelection', Session.get('myProfile').currentWarehouse)

  scope.availableWarehouses = Schema.warehouses.find({merchant: scope.currentMerchant._id}) if scope.currentMerchant