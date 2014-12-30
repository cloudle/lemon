lemon.defineWidget Template.productManagementBasicImportDetails,
  isShowDisableMode: -> Session.get("productManagementCurrentProduct")?.basicDetailModeEnabled
  saleDetails: -> Schema.saleDetails.find {productDetail: @_id}
  buyerName: -> Schema.customers.findOne(Schema.sales.findOne(@sale)?.buyer)?.name

  detailEditingMode: -> Session.get("productManagementDetailEditingRow")?._id is @_id
  detailEditingData: -> Session.get("productManagementDetailEditingRow")
  expireDate: -> if @expire then moment(@expire).format('DD/MM/YYYY') else 'KHÔNG'
  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit
  totalPrice: -> @importPrice*@unitQuality
  unitSaleQuality: -> Math.round(@quality/@conversionQuality*100)/100
  isShowDisableMode: -> !Session.get("productManagementCurrentProduct")?.basicDetailModeEnabled

  events:
    "click .edit-detail": ->
      product = Session.get("productManagementCurrentProduct")
      if product.basicDetailModeEnabled
        Session.set("productManagementDetailEditingRowId", @_id)
      else
        Session.set("productManagementDetailEditingRowId")

    "click .delete-basicDetail": ->
      if Session.get("productManagementCurrentProduct")?.basicDetailModeEnabled
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
