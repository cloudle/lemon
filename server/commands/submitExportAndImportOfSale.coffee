Meteor.methods
  createSaleExport: (saleId)->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      # kiểm tra quyền

      if currentSale = Schema.sales.findOne({
          _id       : saleId
          merchant  : userProfile.currentMerchant
          status    : true
          received  : true
          exported  : false
          imported  : false
          submitted : false
          paymentsDelivery: {$in:[0,1]} })

        for saleDetail in Schema.saleDetails.find({sale: currentSale._id}).fetch()
          productOption = $inc:{inStockQuality: -saleDetail.quality}

          Schema.products.update saleDetail.product, productOption
          Schema.productDetails.update saleDetail.productDetail, productOption
          Schema.saleDetails.update saleDetail._id, $set:{export: true, exportDate: new Date, status: true}
          Schema.saleExports.insert SaleExport.new(currentSale, saleDetail), (error, result) -> console.log error if error

        #    Notification.saleConfirmByExporter(currentSale._id)
        MetroSummary.updateMetroSummaryBySaleExport(currentSale._id)
        switch currentSale.paymentsDelivery
          when 0
            Schema.sales.update currentSale._id, $set:{submitted: true, exported: true}
          when 1
            Schema.sales.update currentSale._id, $set:{exported: true, status: false}
            Schema.deliveries.update currentSale.delivery, $set:{status: 3, exporter: Meteor.userId()}
        return 'create ExportSale'
      else
        throw new Meteor.Error('saleExportError', 'Phiếu bán hàng không tồn tại')


  createSaleImport: (saleId)->
    if userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
      # kiểm tra quyền

      if currentSale = Schema.sales.findOne({
        _id       : saleId
        merchant  : userProfile.currentMerchant
        status    : true
        received  : true
        exported  : true
        imported  : false
        submitted : false
        paymentsDelivery: 1 })

        for saleDetail in Schema.saleDetails.find({sale: currentSale._id}).fetch()
          option = {availableQuality: saleDetail.quality, inStockQuality  : saleDetail.quality}
          Schema.productDetails.update saleDetail.productDetail, $inc: option
          Schema.products.update saleDetail.product, $inc: option

  #      Schema.saleExports.insert SaleExport.new(currentSale, saleDetail), (error, result) -> console.log error if error
  #      Notification.saleConfirmImporter(currentSale._id)
        MetroSummary.updateMetroSummaryBySaleImport(currentSale._id)
        Schema.sales.update currentSale._id, $set:{imported: true, status: false}
        Schema.deliveries.update currentSale.delivery, $set:{status: 9, importer: Meteor.userId()}
        console.log 'create ImportSale'
      else
        throw new Meteor.Error('saleImportError', 'Phiếu bán hàng không tồn tại')