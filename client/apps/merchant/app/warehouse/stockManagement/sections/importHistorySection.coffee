scope = logics.stockManagement

lemon.defineHyper Template.stockManagementSalesHistorySection,
  defaultImport: ->
    if product = Session.get("stockManagementCurrentProduct")
      allProductDetail = Schema.productDetails.find({product: product._id}).fetch()
      Schema.imports.find {_id: {$in: _.union(_.pluck(allProductDetail, 'import'))}}


#  events:
#    "click .expandSaleAndCustomSale": ->
#      if stock = Session.get("stockManagementCurrentProduct")
#        limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
#        if stock.customSaleModeEnabled
#          currentRecords = Schema.customSales.find({buyer: stock._id}).count()
#        else
#          currentRecords = Schema.customSales.find({buyer: stock._id}).count() + Schema.sales.find({buyer: stock._id}).count()
#        Meteor.subscribe('stockManagementData', stock._id, currentRecords, limitExpand)
#        Session.set("stockManagementDataMaxCurrentRecords", currentRecords + limitExpand)
#
#    "click .customSaleModeDisable":  (event, template) ->
#      scope.customSaleModeDisable(stock._id) if stock = Session.get("stockManagementCurrentProduct")
#
##----Create-Transaction-Of-CustomSale-----------------------------------------------------------------------
#    "keydown input.new-bill-field.number": (event, template) ->
#      scope.checkAllowCreateCustomSale(template, stock) if stock = Session.get("stockManagementCurrentProduct")
#
#    "click .createCustomSale":  (event, template) ->
#      scope.createCustomSale(template) if Session.get("allowCreateCustomSale")
#
#    "keypress input.new-bill-field": (event, template) ->
#      scope.createCustomSale(template) if event.which is 13 and Session.get("allowCreateCustomSale")
#
##----Create-Transaction-Of-CustomSale-----------------------------------------------------------------------
#    "keydown .new-transaction-custom-sale-field": (event, template) ->
#      scope.checkAllowCreateTransactionOfCustomSale(template, stock) if stock = Session.get("stockManagementCurrentProduct")
#
#    "click .createTransactionOfCustomSale": (event, template) ->
#      scope.createTransactionOfCustomSale(template) if Session.get("allowCreateTransactionOfCustomSale")
#
#    "keypress input.new-transaction-custom-sale-field": (event, template) ->
#      scope.createTransactionOfCustomSale(template) if event.which is 13 and Session.get("allowCreateTransactionOfCustomSale")
#
##----Create-Transaction-Of-Sale-----------------------------------------------------------------------
#    "click .createTransactionOfSale": (event, template) ->
#      scope.createTransactionOfSale(template) if Session.get("allowCreateTransactionOfSale")
#
#    "keypress input.new-transaction-sale-field": (event, template) ->
#      scope.createTransactionOfSale(template) if event.which is 13 and Session.get("allowCreateTransactionOfSale")
