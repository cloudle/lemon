scope = logics.productManagement

lemon.defineHyper Template.productManagementSalesHistorySection,
  unitName: -> Schema.productUnits.findOne(@unit).unit
  detailEditingMode: -> Session.get("productManagementDetailEditingRow")?._id is @_id
  detailEditingData: -> Session.get("productManagementDetailEditingRow")
  expireDate: -> if @expire then moment(@expire).format('DD/MM/YYYY')

  basicDetails: ->
    if product = Session.get("productManagementCurrentProduct")
      Schema.productDetails.find({product: product._id, import: {$exists: false}}).fetch()


  newImport: ->
    if product = Session.get("productManagementCurrentProduct")
      allProductDetail = Schema.productDetails.find({product: product._id import: {$exists: true}}).fetch()
      currentImport = Schema.imports.find {_id: {$in: _.union(_.pluck(allProductDetail, 'import'))}}

      return {
      detail: currentImport
      importQuality: 0
      inStockQuality: 0
      }

#  rendered: ->
#    @ui.$expireDate.inputmask("dd/mm/yyyy")
#    @ui.$unitQuality.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11})
#    @ui.$unitPrice.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})


  events:
    "click .edit-detail": ->
      product = Session.get("productManagementCurrentProduct")
      if product.basicDetailModeEnabled
        Session.set("productManagementDetailEditingRowId", @_id)
      else
        Session.set("productManagementDetailEditingRowId")

    "click .basicDetailModeDisable": ->
      if product = Session.get("productManagementCurrentProduct")
        Schema.products.update product._id, $set:{basicDetailModeEnabled: false}
        Schema.productDetails.find({product: product._id, import: {$exists: false} }).forEach(
          (item)-> Schema.productDetails.update item._id, $set: {allowDelete: false}
        )
        Session.set("productManagementDetailEditingRowId")



    "click .delete-basicDetail": ->
      if @allowDelete
        Schema.productDetails.remove(@_id)
        Schema.products.update @product, $inc:{
          totalQuality    : -@importQuality
          availableQuality: -@importQuality
          inStockQuality  : -@importQuality
        }
        if !Schema.productDetails.findOne({unit: @unit}) then Schema.productUnits.update @unit, $set:{allowDelete: true}

