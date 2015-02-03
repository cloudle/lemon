scope = logics.agencyProductManagement

lemon.defineWidget Template.agencyProductManagementBasicImportDetails,
  isShowDisableMode: -> Session.get("agencyProductManagementCurrentProduct")?.basicDetailModeEnabled
  saleDetails: -> Schema.saleDetails.find {productDetail: @_id}
  buyerName: -> Schema.customers.findOne(Schema.sales.findOne(@sale)?.buyer)?.name

  detailEditingMode: -> Session.get("agencyProductManagementDetailEditingRow")?._id is @_id
  detailEditingData: -> Session.get("agencyProductManagementDetailEditingRow")
  expireDate: -> if @expire then moment(@expire).format('DD/MM/YYYY') else 'KHÔNG'
  totalPrice: -> @unitPrice*@unitQuality
  unitSaleQuality: -> Math.round(@quality/@conversionQuality*100)/100
  isShowDisableMode: -> !Session.get("agencyProductManagementCurrentProduct")?.basicDetailModeEnabled

  events:
    "click .edit-detail": ->
      product = Session.get("agencyProductManagementCurrentProduct")
      if product.basicDetailModeEnabled
        Session.set("agencyProductManagementDetailEditingRowId", @_id)
      else
        Session.set("agencyProductManagementDetailEditingRowId")

    "click .delete-basicDetail": ->
      product = Session.get("agencyProductManagementCurrentProduct")
      branchProductSummary = Session.get('agencyProductManagementBranchProductSummary')
      productDetail = @
      scope.deleteBasicProductDetail(product, productDetail, branchProductSummary, Session.get('myProfile'))
