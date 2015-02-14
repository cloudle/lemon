scope = logics.productManagement

lemon.defineWidget Template.productManagementBasicImportDetails,
  isShowDisableMode: -> Session.get("productManagementCurrentProduct")?.basicDetailModeEnabled
  saleDetails: ->
    partnerImportList = Schema.saleDetails.find({productDetail: @_id}, {sort: {'version.createdAt': 1}}).fetch()
    partnerSaleList   = Schema.partnerSaleDetails.find({productDetail: $elemMatch: {productDetail: @_id}}, {sort: {'version.createdAt': 1}}).fetch()
    _.sortBy partnerImportList.concat(partnerSaleList), (item) -> item.version.createdAt

  buyerName: ->
    if @partnerSales then Schema.partners.findOne(Schema.partnerSales.findOne(@partnerSales)?.partner)?.name
    else Schema.customers.findOne(Schema.sales.findOne(@sale)?.buyer)?.name

  detailEditingMode: -> Session.get("productManagementDetailEditingRow")?._id is @_id
  detailEditingData: -> Session.get("productManagementDetailEditingRow")
  expireDate: -> if @expire then moment(@expire).format('DD/MM/YYYY') else 'KHÔNG'
  totalPrice: -> @unitPrice*@unitQuality
  finalPrice: -> if @partnerSales then @unitPrice*@unitQuality else @finalPrice
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
