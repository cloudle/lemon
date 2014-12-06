Schema.add 'orders', "Order", class Order
  @findBy: (orderId, warehouseId = null, merchantId = null)->
    if myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
      @schema.findOne({
        _id      : orderId
        creator  : myProfile.user
        merchant : merchantId ? myProfile.currentMerchant
        warehouse: warehouseId ? myProfile.currentWarehouse
      })

  @myHistory: (creatorId, warehouseId = null, merchantId = null)->
    if myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
      @schema.find({
        creator   : creatorId ? myProfile.user
        warehouse : warehouseId ? myProfile.currentWarehouse
        merchant  : merchantId ? myProfile.currentMerchant
      })

  @createdNewBy: (buyer, myProfile = null)->
    if !myProfile then myProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    orderOption =
      merchant  : myProfile.currentMerchant
      warehouse : myProfile.currentWarehouse
      creator   : myProfile.user
      seller    : myProfile.user
      buyer     : buyer?._id ? 'null'
      tabDisplay: if buyer then Helpers.respectName(buyer.name, buyer.gender) else 'PHIẾU BÁN HÀNG 01'

    orderOption._id = @schema.insert orderOption

    return orderOption


#  updateContactName     : (value)-> @schema.update(@id, {$set:{contactName:     value}})
#  updateContactPhone    : (value)-> @schema.update(@id, {$set:{contactPhone:    value}})
#  updateDeliveryAddress : (value)-> @schema.update(@id, {$set:{deliveryAddress: value}})
#  updateComment         : (value)-> @schema.update(@id, {$set:{comment:         value}})
  updateDeliveryDate    : (expire)->
    if expire > (new Date)
      expireDate = new Date(expire.getFullYear(), expire.getMonth(), expire.getDate())
      option = $set: {deliveryDate: expireDate}
    else
      option = $unset: {deliveryDate: true}
    @schema.update(@id, option)


