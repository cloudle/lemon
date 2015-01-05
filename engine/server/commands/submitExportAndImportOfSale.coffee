Meteor.methods
  createSaleExport: (saleId)->
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      # kiểm tra quyền

      if currentSale = Schema.sales.findOne({
          _id       : saleId
          merchant  : profile.currentMerchant
          status    : true
          received  : true
          exported  : false
          imported  : false
          submitted : false
          paymentsDelivery: {$in:[0,1]} })

        for saleDetail in Schema.saleDetails.find({sale: currentSale._id}).fetch()

          if !product = Schema.products.findOne(saleDetail.product) then throw new Meteor.Error('saleExportError', 'Sai thong tin san pham.')
          if product.basicDetailModeEnabled is false
            productOption = $inc:{inStockQuality: -saleDetail.quality}
            Schema.products.update saleDetail.product, productOption
            Schema.productDetails.update saleDetail.productDetail, productOption

          Schema.saleDetails.update saleDetail._id, $set:{export: true, exportDate: new Date, status: true}
          Schema.saleExports.insert SaleExport.new(currentSale, saleDetail), (error, result) -> console.log error if error

#        MetroSummary.updateMetroSummaryBySaleExport(currentSale._id)
        Meteor.call 'saleConfirmByExporter', profile, currentSale._id
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
    if profile = Schema.userProfiles.findOne({user: Meteor.userId()})
      # kiểm tra quyền

      if currentSale = Schema.sales.findOne({
        _id       : saleId
        merchant  : profile.currentMerchant
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
        Meteor.call 'saleConfirmImporter', profile, currentSale._id
        MetroSummary.updateMetroSummaryBySaleImport(currentSale._id)
        Schema.sales.update currentSale._id, $set:{imported: true, status: false}
        Schema.deliveries.update currentSale.delivery, $set:{status: 9, importer: Meteor.userId()}
        console.log 'create ImportSale'
      else
        throw new Meteor.Error('saleImportError', 'Phiếu bán hàng không tồn tại')