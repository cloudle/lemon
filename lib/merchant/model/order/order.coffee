Schema.add 'orders', class Order
  @currentOrder: (orderId, merchantId, warehouseId)->
    @schema.findOne({
      _id      : orderId
      creator  : Meteor.userId()
      merchant : merchantId
      warehouse: warehouseId
    })

  @history: (merchantId, warehouseId)->
    @schema.find({
      creator  : Meteor.userId()
      merchant : merchantId
      warehouse: warehouseId
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


