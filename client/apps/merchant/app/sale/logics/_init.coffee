logics.sales = {}
logics.sales.syncMyProfile = ->
  logics.sales.myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
logics.sales.syncMyOption = ->
  logics.sales.myOption = Schema.userOptions.findOne({user: Meteor.userId()})
logics.sales.syncMySession = ->
  logics.sales.mySession = Schema.userSessions.findOne({user: Meteor.userId()})


logics.sales.syncCurrentBranchStaff  = ->
  logics.sales.currentBranchStaff = Meteor.users.find({})

logics.sales.syncCurrentOrderSeller = ->
  if logics.sales.currentOrder
    logics.sales.currentOrderSelle = Meteor.users.find(logics.sales.currentOrder.seller)

logics.sales.syncCurrentAllCustomers  = ->
  if logics.sales.myProfile
    logics.sales.currentAllCustomers = Customer.insideMerchant(logics.sales.myProfile.parentMerchant)

logics.sales.syncCurrentWarehouseProducts = ->
  if logics.sales.myProfile
    logics.sales.currentWarehouseProducts = Product.insideWarehouse(logics.sales.myProfile.currentWarehouse)

logics.sales.syncCurrentAllSkulls = ->
  if logics.sales.myProfile
    logics.sales.currentAllSkulls = Skull.insideMerchant(logics.sales.myProfile.parentMerchant)

logics.sales.syncCurrentAllProviders = ->
  if logics.sales.myProfile
    logics.sales.currentAllProviders = Provider.insideMerchant(logics.sales.myProfile.parentMerchant)

logics.sales.syncCurrentOrderHistory = ->
  if logics.sales.myProfile
    logics.sales.currentOrderHistory = Order.history(
      logics.sales.myProfile.currentMerchant,
      logics.sales.myProfile.currentWarehouse
    )

logics.sales.syncCurrentOrder = ->
#  if logics.sales.mySession && logics.sales.myProfile
  if logics.sales.myProfile
    logics.sales.currentOrder = Order.currentOrder(
#      logics.sales.mySession.currentOrder
      logics.sales.myProfile.currentOrder
      logics.sales.myProfile.currentMerchant,
      logics.sales.myProfile.currentWarehouse
    )

logics.sales.syncCurrentOrderBuyer = ->
  logics.sales.currentOrderBuyer =
    if logics.sales.currentOrder?.buyer
      Customer.findOne(logics.sales.currentOrder.buyer)
    else {}





