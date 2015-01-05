logics.returns.reCalculateReturn = (returnId)->
  return console.log("Phiếu trả hàng không tồn tại.") if !saleReturn = Schema.returns.findOne(returnId)
  returnDetails = Schema.returnDetails.find({return: saleReturn._id}).fetch()
  option=
    totalPrice     :0
    productQuality :0
    productSale    :0

  if returnDetails.length > 0
    for detail in returnDetails
#      discountPercent
      option.totalPrice     += Math.round(detail.price * detail.returnQuality * (100 - detail.discountPercent)/100)
      option.productQuality += detail.returnQuality
      option.productSale    += 1

    option.discountCash = (saleReturn.discountPercent * option.totalPrice)/100
    option.finallyPrice = option.totalPrice - option.discountCash
    console.log option
  Schema.returns.update saleReturn._id, $set: option