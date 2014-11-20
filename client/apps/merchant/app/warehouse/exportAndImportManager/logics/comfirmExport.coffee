#saleStatusIsExport = (sale)->
#  if sale.status == sale.received == true and sale.submitted == sale.exported == sale.imported == false and (sale.paymentsDelivery == 0 || sale.paymentsDelivery == 1)
#    true
#  else
#    false
#
#saleStatusIsImport = (sale)->
#  if sale.status == sale.received == sale.exported == true and sale.submitted == sale.imported == false and sale.paymentsDelivery == 1
#    true
#  else
#    false
#
#logics.exportAndImportManager.createSaleExport= (currentSale)->
#  if saleStatusIsExport(currentSale)
#    saleDetails = Schema.saleDetails.find({sale: currentSale._id}).fetch()
#    console.log saleDetails
#    for detail in saleDetails
#      Schema.saleDetails.update detail._id, $set:{exported: true, exportDate: new Date, status: true}
#      Schema.productDetails.update detail.productDetail , $inc:{inStockQuality: -detail.quality}
#      Schema.products.update detail.product,   $inc:{inStockQuality: -detail.quality}
#
#      Schema.saleExports.insert SaleExport.new(currentSale, detail), (error, result) -> console.log error if error
#
##    Notification.saleConfirmByExporter(currentSale._id)
#    MetroSummary.updateMetroSummaryBySaleExport(currentSale._id)
#    if currentSale.paymentsDelivery == 0 then  Schema.sales.update currentSale._id, $set:{submitted: true, exported: true}
#    if currentSale.paymentsDelivery == 1
#      Schema.sales.update currentSale._id, $set:{exported: true, status: false}
#      Schema.deliveries.update currentSale.delivery, $set:{status: 3, exporter: Meteor.userId()}
#    console.log 'create ExportSale'
#
#  if saleStatusIsImport(currentSale)
#    saleDetails = Schema.saleDetails.find({sale: currentSale._id}).fetch()
#    for detail in saleDetails
#      option =
#        availableQuality: detail.quality
#        inStockQuality  : detail.quality
#      Schema.productDetails.update detail.productDetail, $inc: option
#      Schema.products.update detail.product, $inc: option
#
#    #        Schema.saleExports.insert SaleExport.new(currentSale, detail), (error, result) -> console.log error if error
#    #      Notification.saleConfirmImporter(currentSale._id)
#    MetroSummary.updateMetroSummaryBySaleImport(currentSale._id)
#    Schema.sales.update currentSale._id, $set:{imported: true, status: false}
#    Schema.deliveries.update currentSale.delivery, $set:{status: 9, importer: Meteor.userId()}
#    console.log 'create ImportSale'
