createNewOrder = (myProfile, buyer)->
  option =
    merchant  : myProfile.currentMerchant
    warehouse : myProfile.currentWarehouse
    creator   : myProfile.user
    seller    : myProfile.user
    buyer     : buyer._id ? 'null'

  if buyer then option.tabDisplay = Helpers.respectName(buyer.name, buyer.gender)
  option._id = Schema.orders.insert(option)
  option

logics.sales.createNewOrderAndSelected = ->
  if !logics.sales.currentOrder
    buyer = Schema.customers.findOne({parentMerchant: logics.sales.myProfile.parentMerchant})
    newOrder = createNewOrder(logics.sales.myProfile, buyer)
    logics.sales.selectOrder(newOrder._id)

