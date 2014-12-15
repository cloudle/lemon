logics.productManagement = {}
Apps.Merchant.productManagementInit = []
Apps.Merchant.productManagementReactive = []

Apps.Merchant.productManagementReactive.push (scope) ->

#  if product = Session.get("productManagementCurrentStock")
#    maxRecords = Session.get("productManagementDataMaxCurrentRecords")
#    countRecords = Schema.customSales.find({buyer: product._id}).count()
#    countRecords += Schema.sales.find({buyer: product._id}).count() if product.customSaleModeEnabled is false
#    Session.set("showExpandSaleAndCustomSale", (maxRecords is countRecords))
#
#    latestCustomSale = Schema.customSales.findOne({buyer: product._id}, {sort: {debtDate: -1}})
#    if latestCustomSale
#      if latestTransaction = Schema.transactions.findOne({latestSale: latestCustomSale._id}, {sort: {debtDate: -1}})
#        $("[name=paidDate]").val(moment(latestTransaction.debtDate).format('DDMMYYY'))
#      else
#        $("[name=paidDate]").val(moment(latestCustomSale.debtDate).format('DDMMYYY'))
#
  if productId = Session.get("mySession")?.currentProductManagementSelection
    Session.set("productManagementCurrentProduct", Schema.products.findOne(productId))

  if Session.get("productManagementUnitEditingRowId")
    Session.set("productManagementUnitEditingRow", Schema.productUnits.findOne(Session.get("productManagementUnitEditingRowId")))

  if Session.get("productManagementDetailEditingRowId")
    Session.set("productManagementDetailEditingRow", Schema.productDetails.findOne(Session.get("productManagementDetailEditingRowId")))


