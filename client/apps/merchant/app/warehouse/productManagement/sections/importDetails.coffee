lemon.defineWidget Template.productManagementImportDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("productManagementCurrentProduct").customSaleDebt
  providerName: -> Schema.providers.findOne(@provider)?.name

  distributorName: ->
    if distributorId = Schema.imports.findOne(@import).distributor
      Schema.distributors.findOne(distributorId)?.name

  totalPrice: -> @importPrice * @importQuality
  expireDate: -> if @exprire then moment(@exprire).format('DD/MM/YYYY') else 'KHÔNG'

  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find {import: importId, product: Session.get("productManagementCurrentProduct")._id}

  saleDetails: -> Schema.saleDetails.find {productDetail: @_id}
  buyerName: -> Schema.customers.findOne(Schema.sales.findOne(@sale)?.buyer)?.name
