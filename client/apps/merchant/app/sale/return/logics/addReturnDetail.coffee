logics.returns.addReturnDetail= (saleId)->
  return console.log('Phiếu bán hàng không tồn tại') if !sale = Schema.sales.findOne({_id: saleId})
  return console.log("Chưa chọn sản phẩm trả hàng") if !sale.currentProductDetail
  return console.log("Sản phẩm trả hàng không tồn tại") if !saleDetail = Schema.saleDetails.findOne({_id: sale.currentProductDetail})
  return console.log("Số lượng sản phẩm phải lớn hơn 0") if !sale.currentQuality || sale.currentQuality < 1
  return console.log("Số lần trả vượt quá 3 lần, không thể trả tiếp.") if sale.returnCount > 3


  if returns = Schema.returns.findOne({_id: sale.currentReturn})
    return console.log("Phiếu đang chờ duyệt, không thể thêm sản phẩm.") if returns.status == 1
    returns = Return.createBySale(saleId) if returns.status == 2
  else
    returns = Return.createBySale(saleId)
  return console.log("Không thể tạo phiếu trả hàng.") if !returns

  returnDetail = ReturnDetail.newByReturn(returns._id, saleId)
  returnDetails = Schema.returnDetails.find({return: returns._id}).fetch()

  findReturnDetail =_.findWhere(returnDetails,{
    productDetail   : returnDetail.productDetail
    price           : returnDetail.price
    discountPercent : returnDetail.discountPercent
  })

  if findReturnDetail
    return console.log('Vuot Qua SL Hang Co') if saleDetail.quality < (findReturnDetail.returnQuality + returnDetail.returnQuality)
    Schema.returnDetails.update findReturnDetail._id, $inc:{
      returnQuality : returnDetail.returnQuality
      discountCash  : returnDetail.discountCash
      finalPrice    : returnDetail.finalPrice
    }
  else
    return console.log('Vuot Qua SL Hang Co') if saleDetail.quality <  returnDetail.returnQuality
    Schema.returnDetails.insert returnDetail
  logics.returns.reCalculateReturn(returns._id)