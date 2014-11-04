logics.returns.removeReturnDetail = (returnDetailId)->
  returnDetail = Schema.returnDetails.findOne({_id: returnDetailId})
  return console.log('Chi tiết trả hàng không tồn tại') if !returnDetail
  if returnDetail.submit == true
    return console.log('Phiếu trả hàng đã xác nhận, không thể xóa.')
  else
    Schema.returnDetails.remove returnDetail._id
    if Schema.returnDetails.findOne({return: returnDetail.return})
      logics.returns.reCalculateReturn(returnDetail.return)
    else
      Schema.sales.update returnDetail.sale, $set:{status: true }
      Schema.returns.remove(returnDetail.return)