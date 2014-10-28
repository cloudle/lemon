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
    logics.sales.currentOrderSeller = Meteor.users.findOne(logics.sales.currentOrder.seller)


logics.sales.syncCurrentOrder = ->
  if logics.sales.mySession && logics.sales.myProfile
    logics.sales.currentOrder = Order.currentOrder(
      logics.sales.mySession.currentOrder
      logics.sales.myProfile.currentMerchant,
      logics.sales.myProfile.currentWarehouse
    )

logics.sales.syncCurrentProduct = ->
  if logics.sales.currentOrder
    logics.sales.currentProduct = Schema.products.findOne(logics.sales.currentOrder.currentProduct)

logics.sales.syncSale = ->
  if logics.sales.myProfile
    logics.sales.currentWarehouseProducts = Product.insideWarehouse(logics.sales.myProfile.currentWarehouse)
    logics.sales.currentAllCustomers      = Customer.insideMerchant(logics.sales.myProfile.parentMerchant)
    logics.sales.currentAllSkulls         = Skull.insideMerchant(logics.sales.myProfile.parentMerchant)
    logics.sales.currentBranchProviders   = Provider.insideBranch(logics.sales.myProfile.currentMerchant)
  #    logics.sales.currentAllProviders = Provider.insideMerchant(logics.sales.myProfile.parentMerchant)
    logics.sales.currentOrderHistory      = Order.history(logics.sales.myProfile.currentMerchant,
                                                  logics.sales.myProfile.currentWarehouse)

#logics.sales.currentOrderDetails = OrderDetail.find({order: logics.sales.currentOrder._id})

logics.sales.syncCurrentOrderBuyer = ->
  logics.sales.currentOrderBuyer =
    if logics.sales.currentOrder?.buyer
      Customer.findOne(logics.sales.currentOrder.buyer)
    else {}





