lemon.defineWidget Template.productManagementImportDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("productManagementCurrentProduct").customSaleDebt
  providerName: -> Schema.providers.findOne(@provider)?.name
  unitSaleQuality: -> Math.round(@quality/@conversionQuality*100)/100
  isShowDisableMode: -> !Session.get("productManagementCurrentProduct")?.basicDetailModeEnabled

  distributorName: ->
    if distributorId = Schema.imports.findOne(@import).distributor
      Schema.distributors.findOne(distributorId)?.name

  totalPrice: -> @importPrice * @importQuality
  expireDate: -> if @expire then moment(@expire).format('DD/MM/YYYY') else 'KHÔNG'
  saleQuality: -> @quality - @returnQuality
  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit

  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find {import: importId, product: Session.get("productManagementCurrentProduct")._id}

  saleDetails: -> Schema.saleDetails.find {productDetail: @_id}
  buyerName: -> Schema.customers.findOne(Schema.sales.findOne(@sale)?.buyer)?.name
