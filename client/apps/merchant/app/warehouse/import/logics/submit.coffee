navigateNewTab=(currentImportId)->
  allTabs = logics.import.myHistory.fetch()
  currentSource = _.findWhere(allTabs, {_id: currentImportId})
  currentIndex = allTabs.indexOf(currentSource)
  currentLength = allTabs.length

  if currentLength > 1
    nextIndex = if currentIndex == currentLength - 1 then currentIndex - 1 else currentIndex + 1
    UserSession.set('currentImport', allTabs[nextIndex]._id)
  else
    logics.import.createImportAndSelected()

Apps.Merchant.importInit.push (scope) ->
  logics.import.submit = (importId) ->
    currentImport = Schema.imports.findOne({_id: importId, finish: true, submitted: false})
    if currentImport
      importDetails = Schema.importDetails.find({import: importId}).fetch()
      for importDetail in importDetails
        product = Schema.products.findOne importDetail.product
        return console.log('Không tìm thấy sản phẩm id:'+ importDetail.product) if !product

      for importDetail in importDetails
        productDetail= ProductDetail.newProductDetail(currentImport, importDetail)
        Schema.productDetails.insert productDetail, (error, result) ->
          if error then return console.log('Sai thông tin sản phẩm nhập kho')

        product = Schema.products.findOne importDetail.product
        option1=
          totalQuality    : importDetail.importQuality
          availableQuality: importDetail.importQuality
          inStockQuality  : importDetail.importQuality

        option2=
          provider    : importDetail.provider
          importPrice : importDetail.importPrice
        option2.price = importDetail.salePrice if importDetail.salePrice

        Schema.products.update product._id, $inc: option1, $set: option2, (error, result) ->
          if error then return console.log('Sai thông tin sản phẩm nhập kho')

      navigateNewTab(currentImport._id)
      Schema.imports.update currentImport._id, $set:{finish: true, submitted: true}
      warehouseImport = Schema.imports.findOne(importId)
#      transaction = Transaction.newByImport(warehouseImport)
#      transactionDetail = TransactionDetail.newByTransaction(transaction)
  #    MetroSummary.updateMetroSummaryByImport(importId)



      return ('Phiếu nhập kho đã được duyệt')
    else
      return ('Đã có lỗi trong quá trình xác nhận')