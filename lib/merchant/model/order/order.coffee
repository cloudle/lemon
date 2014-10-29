Schema.add 'orders', class Order
  @findBy: (orderId, merchantId = null, warehouseId = null)->
    if !merchantId && !warehouseId then myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.findOne({
      _id      : orderId
      creator  : myProfile.user
      merchant : merchantId ? myProfile.currentMerchant
      warehouse: warehouseId ? myProfile.currentWarehouse
    })

  @history: (merchantId = null, warehouseId = null)->
    if !merchantId && !warehouseId then myProfile= Schema.userProfiles.findOne({user: Meteor.userId()})
    @schema.find({
      creator  : Meteor.userId()
      merchant : merchantId ? myProfile.currentMerchant
      warehouse: warehouseId ? myProfile.currentWarehouse
    })




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


