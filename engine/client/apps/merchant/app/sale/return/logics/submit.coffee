logics.returns. submitReturn = (returnId)->
  try
    throw 'Lỗi, Bạn chưa đăng nhập.' if !userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    throw 'Lỗi, Phiếu trả không chính xác.' if !currentReturn = Schema.returns.findOne({_id: returnId, creator: userProfile.user})
#    throw 'Bạn không có quyền xác nhận.' unless Role.hasPermission(userProfile._id, Sky.system.merchantPermissions.saleExport.key)
    if currentReturn.status == 1
      returnQuality = 0
      for returnDetail in Schema.returnDetails.find({return: currentReturn._id, submit: true}).fetch()
        returnQuality = returnDetail.returnQuality
        option =
          availableQuality       : returnDetail.returnQuality
          inStockQuality         : returnDetail.returnQuality
          returnQualityByCustomer: returnDetail.returnQuality

        Schema.productDetails.update returnDetail.productDetail, $inc: option
        Schema.branchProductSummaries.update returnDetail.branchProduct, $inc: option
        Schema.products.update returnDetail.product, $inc: option

        Schema.saleDetails.update returnDetail.saleDetail, $inc:{returnQuality: returnDetail.returnQuality}
        saleDetail = Schema.saleDetails.findOne(returnDetail.saleDetail)
        unless saleDetail.quality is saleDetail.returnQuality then unLockReturn = true

      Schema.returns.update currentReturn._id, $set: {status: 2, 'version.createdAt': new Date()}
      Schema.sales.update currentReturn.sale, $set:{status: true, return: true, returnLock: !unLockReturn}, $inc:{returnCount: 1, returnQuality: returnQuality}

      transaction =  Transaction.newByReturn(currentReturn)
      transactionDetail = TransactionDetail.newByTransaction(transaction)
      MetroSummary.updateMetroSummaryByReturn(currentReturn._id, returnQuality)
      Meteor.call 'returnSubmit', userProfile, returnId
      throw 'Ok, Phiếu đã được duyệt bởi quản lý.'
    throw 'Lỗi, Phiếu chưa được xác nhận từ nhân viên.' if currentReturn.status == 0
    throw 'Lỗi, Phiếu đã được duyệt, không thể thao tác.' if currentReturn.status == 2
  catch error
    console.log error
