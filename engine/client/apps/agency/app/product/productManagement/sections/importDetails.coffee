scope = logics.agencyProductManagement

lemon.defineWidget Template.agencyProductManagementImportDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get(scope.agencyProductManagementCurrentProduct).customSaleDebt
  providerName: -> Schema.providers.findOne(@provider)?.name
  unitSaleQuality: -> Math.round(@quality/@conversionQuality*100)/100
  isShowDisableMode: -> !Session.get(scope.agencyProductManagementCurrentProduct)?.basicDetailModeEnabled

  distributorName: -> Schema.distributors.findOne(Schema.imports.findOne(@import)?.distributor)?.name
  buyerName:   -> Schema.customers.findOne(Schema.sales.findOne(@sale)?.buyer)?.name
  totalPrice:  -> @unitPrice * @unitQuality
  expireDate:  -> if @expire then moment(@expire).format('DD/MM/YYYY') else 'KHÔNG'
  saleQuality: -> @quality - @returnQuality
  distributorReturnQuality: (temp)-> console.log @

  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find {import: importId, product: Session.get(scope.agencyProductManagementCurrentProduct)._id}

  saleDetails: -> Schema.saleDetails.find {productDetail: @_id}
  returnDetails: ->
    return {
      productDetail: @
      returnDetails: Schema.returnDetails.find {productDetail: $elemMatch: {productDetail: @_id}}
    }

lemon.defineWidget Template.agencyProductManagementReturnDetails,
  returnQuality: ->
    for detail in @productDetail
      if detail.productDetail is UI._templateInstance().data.productDetail._id
        return detail.returnQuality/@conversionQuality

  returnFinalPrice: ->
    for detail in @productDetail
      if detail.productDetail is UI._templateInstance().data.productDetail._id
        return detail.returnQuality*@unitReturnsPrice/@conversionQuality

