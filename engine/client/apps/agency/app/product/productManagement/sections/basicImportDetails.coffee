scope = logics.productManagement

lemon.defineWidget Template.productManagementBasicImportDetails,
  isShowDisableMode: -> Session.get("productManagementCurrentProduct")?.basicDetailModeEnabled
  saleDetails: -> Schema.saleDetails.find {productDetail: @_id}
  buyerName: -> Schema.customers.findOne(Schema.sales.findOne(@sale)?.buyer)?.name

  detailEditingMode: -> Session.get("productManagementDetailEditingRow")?._id is @_id
  detailEditingData: -> Session.get("productManagementDetailEditingRow")
  expireDate: -> if @expire then moment(@expire).format('DD/MM/YYYY') else 'KHÔNG'
  totalPrice: -> @unitPrice*@unitQuality
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
      product = Session.get("productManagementCurrentProduct")
      branchProductSummary = Session.get('productManagementBranchProductSummary')
      productDetail = @
      scope.deleteBasicProductDetail(product, productDetail, branchProductSummary, Session.get('myProfile'))
