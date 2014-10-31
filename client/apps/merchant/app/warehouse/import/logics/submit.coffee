Apps.Merchant.importInit.push (scope) ->
  logics.import.submit = (importId) ->
    currentImport = Schema.imports.findOne({_id: importId, finish: true, submitted: false})
    if currentImport
      importDetails = Schema.importDetails.find({import: importId}).fetch()
      for importDetail in importDetails
        console.log importDetail.products
        product = Schema.products.findOne importDetail.product
        return console.log('Không tìm thấy sản phẩm id:'+ importDetail.product) if !product

      console.log 'tiep'
      for importDetail in importDetails
        productDetail= ProductDetail.newProductDetail(currentImport, importDetail)
        console.log productDetail
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

      Schema.imports.update currentImport._id, $set:{finish: true, submitted: true}
      warehouseImport = Schema.imports.findOne(importId)
#      transaction = Transaction.newByImport(warehouseImport)
#      transactionDetail = TransactionDetail.newByTransaction(transaction)
  #    MetroSummary.updateMetroSummaryByImport(importId)
      return ('Phiếu nhập kho đã được duyệt')
    else
      return ('Đã có lỗi trong quá trình xác nhận')