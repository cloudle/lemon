logics.stockManagement = {}
Apps.Merchant.stockManagementInit = []
Apps.Merchant.stockManagementReactive = []

Apps.Merchant.stockManagementReactive.push (scope) ->

#  if stock = Session.get("stockManagementCurrentStock")
#    maxRecords = Session.get("stockManagementDataMaxCurrentRecords")
#    countRecords = Schema.customSales.find({buyer: stock._id}).count()
#    countRecords += Schema.sales.find({buyer: stock._id}).count() if stock.customSaleModeEnabled is false
#    Session.set("showExpandSaleAndCustomSale", (maxRecords is countRecords))
#
#    latestCustomSale = Schema.customSales.findOne({buyer: stock._id}, {sort: {debtDate: -1}})
#    if latestCustomSale
#      if latestTransaction = Schema.transactions.findOne({latestSale: latestCustomSale._id}, {sort: {debtDate: -1}})
#        $("[name=paidDate]").val(moment(latestTransaction.debtDate).format('DDMMYYY'))
#      else
#        $("[name=paidDate]").val(moment(latestCustomSale.debtDate).format('DDMMYYY'))
#
  if productId = Session.get("mySession")?.currentProductManagementSelection
    Session.set("stockManagementCurrentProduct", Schema.products.findOne(productId))

