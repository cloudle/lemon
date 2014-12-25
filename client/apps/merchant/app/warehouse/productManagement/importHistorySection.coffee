scope = logics.productManagement

lemon.defineHyper Template.productManagementSalesHistorySection,
  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
  detailEditingMode: -> Session.get("productManagementDetailEditingRow")?._id is @_id
  detailEditingData: -> Session.get("productManagementDetailEditingRow")
  expireDate: -> if @expire then moment(@expire).format('DD/MM/YYYY')

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
        if product.basicDetailModeEnabled is true
          Meteor.call('updateProductBasicDetailMode', product._id)

  #        Session.set("productManagementDetailEditingRowId")
  #        Session.set("productManagementDetailEditingRow")
  #        Session.set("productManagementUnitEditingRowId")
  #        Session.set("productManagementUnitEditingRow")

    "click .delete-basicDetail": ->
      if @allowDelete
        Schema.productDetails.remove(@_id)
        if !Schema.productDetails.findOne({unit: @unit}) then Schema.productUnits.update @unit, $set:{allowDelete: true}

        totalQuality = 0
        availableQuality = 0
        inStockQuality = 0
        Schema.productDetails.find({product: @product}).forEach(
          (productDetail) ->
            totalQuality += productDetail.importQuality
            availableQuality += productDetail.availableQuality
            inStockQuality += productDetail.inStockQuality
          )

        productOption =
          totalQuality    : totalQuality
          availableQuality: availableQuality
          inStockQuality  : inStockQuality
        if totalQuality is 0 then productOption.allowDelete = true
        Schema.products.update @product, $set: productOption

        metroSummary = Schema.metroSummaries.findOne({merchant: Session.get('myProfile').currentMerchant})
        Schema.metroSummaries.update metroSummary._id, $inc:{
          stockProductCount: -@importQuality
          availableProductCount: -@importQuality
        }


