logics.sales = { name: 'sale-logics' }
Apps.Merchant.salesInit = []
Apps.Merchant.salesInit.push (scope) ->
  console.log Apps.myProfile
  console.log scope.name
  scope.name = 'cloud-le'

Apps.Merchant.salesInit.push (scope) ->
  console.log scope.name

logics.sales.syncMyProfile = ->
  logics.sales.myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
logics.sales.syncMyOption = ->
  logics.sales.myOption = Schema.userOptions.findOne({user: Meteor.userId()})
logics.sales.syncMySession = ->
  logics.sales.mySession = Schema.userSessions.findOne({user: Meteor.userId()})

logics.sales.syncCurrentOrder = ->
  if mySession = logics.sales.mySession
    logics.sales.currentOrder = Order.findBy(mySession.currentOrder)
    Meteor.subscribe('orderDetails', mySession.currentOrder)

logics.sales.syncCurrentOrderDetails = ->
  logics.sales.currentOrderDetails = OrderDetail.findBy(logics.sales.currentOrder._id) if logics.sales.currentOrder


logics.sales.syncProductAndSellerAndBuyer = ->
  if logics.sales.currentOrder
    logics.sales.currentProduct     = Schema.products.findOne(logics.sales.currentOrder.currentProduct)
    logics.sales.currentOrderBuyer  = Schema.customers.findOne(logics.sales.currentOrder.buyer)
    logics.sales.currentOrderSeller = Meteor.users.findOne(logics.sales.currentOrder.seller)

#load moi thong tin can thiet cho ban hang
logics.sales.syncSale = ->
  if myProfile = logics.sales.myProfile
    logics.sales.currentAllProductsInWarehouse = Product.insideWarehouse(myProfile.currentWarehouse)
    logics.sales.currentAllCustomers           = Customer.insideMerchant(myProfile.parentMerchant)
    logics.sales.currentAllSkulls              = Skull.insideMerchant(myProfile.parentMerchant)
    logics.sales.currentBranchProviders        = Provider.insideBranch(myProfile.currentMerchant)
    logics.sales.currentAllProviders           = Provider.insideMerchant(myProfile.parentMerchant)
    logics.sales.currentOrderHistory           = Order.history(myProfile.currentMerchant, myProfile.currentWarehouse)

  logics.sales.currentBranchStaff              = Meteor.users.find({})
  return
