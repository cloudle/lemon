scope = logics.productManagement

lemon.defineHyper Template.productManagementSalesHistorySection,
  basicDetail: ->
    if product = Session.get("productManagementCurrentProduct")
      productDetailFound = Schema.productDetails.find({product: product._id, import: {$exists: false}})
      return {
        isShowDetail: if @basicDetailModeEnabled then true else productDetailFound.count() > 0
        detail: productDetailFound
      }

  newImport: ->
    if product = Session.get("productManagementCurrentProduct")
      allProductDetail = Schema.productDetails.find({product: product._id, import: {$exists: true}}).fetch()
      currentImport = Schema.imports.find {_id: {$in: _.union(_.pluck(allProductDetail, 'import'))}}
      return {
        isShowDetail: if currentImport.count() > 0 then true else false
        detail: currentImport
      }

  events:
    "click .basicDetailModeDisable": ->
      if product = Session.get("productManagementCurrentProduct")
        if product.basicDetailModeEnabled is true
          Meteor.call('updateProductBasicDetailMode', product._id)
          Session.set("productManagementDetailEditingRowId")
          Session.set("productManagementDetailEditingRow")
          Session.set("productManagementUnitEditingRowId")
          Session.set("productManagementUnitEditingRow")