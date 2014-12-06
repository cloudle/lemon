Apps.Merchant.salesInit.push (scope) ->
  scope.currentAllProductsInWarehouse = Product.insideWarehouse(Session.get('myProfile').currentWarehouse)
  scope.currentAllCustomers           = Customer.insideMerchant(Session.get('myProfile').parentMerchant)
  scope.currentAllSkulls              = Skull.insideMerchant(Session.get('myProfile').parentMerchant)
  scope.currentBranchProviders        = Provider.insideBranch(Session.get('myProfile').currentMerchant)
  scope.currentAllProviders           = Provider.insideMerchant(Session.get('myProfile').parentMerchant)
  scope.currentOrderHistory           = Order.myHistory(Session.get('myProfile').user, Session.get('myProfile').currentWarehouse, Session.get('myProfile').currentMerchant)
  scope.currentBranchStaff            = Meteor.users.find({})





  scope.updateSelectNewProduct = (scope, product)->
    if Session.get('salesCurrentOrderSelected')
    else
      orderId = scope.createNewOrderAndSelected()

    cross = scope.validation.getCrossProductQuality(product._id, orderId)
    maxQuality = (cross.product.availableQuality - cross.quality)
    Schema.orders.update orderId,
      $set:
        currentProduct        : product._id
        currentQuality        : if maxQuality > 0 then 1 else 0
        currentPrice          : product.price
        currentTotalPrice     : product.price
        currentDiscountCash   : Number(0)
        currentDiscountPercent: Number(0)