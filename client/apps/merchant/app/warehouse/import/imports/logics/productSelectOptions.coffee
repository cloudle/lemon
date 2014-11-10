formatProductSearch = (item) -> "#{item.name} [#{item.skulls}]" if item

updateImportSelectNewProduct = (productId)->
  if !logics.import.currentImport
    logics.import.currentImport = logics.import.createImportAndSelected()
    Session.set('currentImport', logics.import.currentImport)

  product = Schema.products.findOne(productId)
  if product
    option =
      currentProduct     : product._id
      currentProvider    : product.provider ? 'skyReset'
      currentQuality     : 1
      currentImportPrice : product.importPrice ? 0
    if product.price > 0 and product.inStockQuality > 0
      Import.update(Session.get('currentImport')._id, $set: option, $unset: {currentPrice: ""})
    else
      option.currentPrice = product.importPrice ? 0
      Import.update(Session.get('currentImport')._id, {$set: option})
#    $("[name=expire]").datepicker('setDate', undefined)
    $("[name=productionDate]").datepicker('setDate', undefined)
    Session.get('timesUseProduct')



Apps.Merchant.importInit.push (scope) ->
  logics.import.productSelectOptions =
    query: (query) -> query.callback
      results: _.filter logics.import.availableProducts.fetch(), (item) ->
        unsignedTerm = Helpers.RemoveVnSigns query.term
        unsignedName = Helpers.RemoveVnSigns item.name

        unsignedName.indexOf(unsignedTerm) > -1 || item.productCode.indexOf(unsignedTerm) > -1
      text: 'name'
    initSelection: (element, callback) ->
      callback(Schema.products.findOne(Session.get('currentImport')?.currentProduct) ? 'skyReset')
    formatSelection: formatProductSearch
    formatResult: formatProductSearch
    id: '_id'
    placeholder: 'CHỌN SẢN PHẨM'
  #    minimumResultsForSearch: -1
    hotkey: 'return'
    changeAction: (e) -> updateImportSelectNewProduct(e.added._id)
    reactiveValueGetter: -> Session.get('currentImport')?.currentProduct  ? 'skyReset'