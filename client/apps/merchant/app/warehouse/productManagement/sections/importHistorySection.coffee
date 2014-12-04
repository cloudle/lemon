scope = logics.productManagement

lemon.defineHyper Template.productManagementSalesHistorySection,
  defaultImport: ->
    if product = Session.get("productManagementCurrentProduct")
      allProductDetail = Schema.productDetails.find({product: product._id}).fetch()
      currentImport = Schema.imports.find {_id: {$in: _.union(_.pluck(allProductDetail, 'import'))}}

      return {
        detail: currentImport
        importQuality: 0
        inStockQuality: 0
      }


  totalImportQuality: ->
  totalInStockQuality: ->

#  events:
#    "click .expandSaleAndCustomSale": ->
#      if product = Session.get("productManagementCurrentProduct")
#        limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
#        if product.customSaleModeEnabled
#          currentRecords = Schema.customSales.find({buyer: product._id}).count()
#        else
#          currentRecords = Schema.customSales.find({buyer: product._id}).count() + Schema.sales.find({buyer: product._id}).count()
#        Meteor.subscribe('productManagementData', product._id, currentRecords, limitExpand)
#        Session.set("productManagementDataMaxCurrentRecords", currentRecords + limitExpand)
#
#    "click .customSaleModeDisable":  (event, template) ->
#      scope.customSaleModeDisable(product._id) if product = Session.get("productManagementCurrentProduct")
#
##----Create-Transaction-Of-CustomSale-----------------------------------------------------------------------
#    "keydown input.new-bill-field.number": (event, template) ->
#      scope.checkAllowCreateCustomSale(template, product) if product = Session.get("productManagementCurrentProduct")
#
#    "click .createCustomSale":  (event, template) ->
#      scope.createCustomSale(template) if Session.get("allowCreateCustomSale")
#
#    "keypress input.new-bill-field": (event, template) ->
#      scope.createCustomSale(template) if event.which is 13 and Session.get("allowCreateCustomSale")
#
##----Create-Transaction-Of-CustomSale-----------------------------------------------------------------------
#    "keydown .new-transaction-custom-sale-field": (event, template) ->
#      scope.checkAllowCreateTransactionOfCustomSale(template, product) if product = Session.get("productManagementCurrentProduct")
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
