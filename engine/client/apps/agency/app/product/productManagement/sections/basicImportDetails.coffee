scope = logics.agencyProductManagement

lemon.defineWidget Template.agencyProductManagementBasicImportDetails,
  isShowDisableMode: -> Session.get(scope.agencyProductManagementCurrentProduct)?.basicDetailModeEnabled
  saleDetails: -> Schema.saleDetails.find {productDetail: @_id}
  buyerName: -> Schema.customers.findOne(Schema.sales.findOne(@sale)?.buyer)?.name

  detailEditingMode: -> Session.get(scope.agencyProductManagementDetailEditingRow)?._id is @_id
  detailEditingData: -> Session.get(scope.agencyProductManagementDetailEditingRow)
  expireDate: -> if @expire then moment(@expire).format('DD/MM/YYYY') else 'KHÔNG'
  totalPrice: -> @unitPrice*@unitQuality
  unitSaleQuality: -> Math.round(@quality/@conversionQuality*100)/100
  isShowDisableMode: -> !Session.get(scope.agencyProductManagementCurrentProduct)?.basicDetailModeEnabled

  events:
    "click .edit-detail": ->
      product = Session.get(scope.agencyProductManagementCurrentProduct)
      if product.basicDetailModeEnabled
        Session.set(scope.agencyProductManagementDetailEditingRowId, @_id)
      else
        Session.set(scope.agencyProductManagementDetailEditingRowId)

    "click .delete-basicDetail": ->
      product = Session.get(scope.agencyProductManagementCurrentProduct)
      branchProductSummary = Session.get(scope.agencyProductManagementBranchProduct)
      productDetail = @
      scope.deleteBasicProductDetail(product, productDetail, branchProductSummary, Session.get('myProfile'))
