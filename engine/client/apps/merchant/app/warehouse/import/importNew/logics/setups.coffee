splitName = (fullText) ->
  if fullText.indexOf("(") > 0
    namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
    skullsPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    return { name: namePart, skulls: [skullsPart] }
  else
    return { name: fullText }


Apps.Merchant.importInit.push (scope) ->
  scope.availableProducts    = Product.insideWarehouse(Session.get('myProfile').currentWarehouse)
  scope.availableSkulls      = Skull.insideMerchant(Session.get('myProfile').parentMerchant)
  scope.availableProviders   = Provider.insideMerchant(Session.get('myProfile').parentMerchant)
  scope.branchProviders      = Provider.insideBranch(Session.get('myProfile').currentMerchant)
  scope.availableDistributor = Distributor.insideMerchant(Session.get('myProfile').currentMerchant)
  scope.availablePartner     = Schema.partners.find({parentMerchant: Session.get('myProfile').parentMerchant})
  scope.myHistory            = Import.myHistory(Session.get('myProfile').user, Session.get('myProfile').currentWarehouse, Session.get('myProfile').currentMerchant)
  scope.myCreateProduct      = Product.canDeleteByMeInside()
  scope.myCreateProvider     = Provider.canDeleteByMe()
  scope.myCreateDistributor  = Distributor.canDeleteByMe()


  scope.editProduct = (template) ->
    newName        = template.ui.$productName.val()
    newPrice       = template.ui.$productPrice.inputmask('unmaskedvalue')
    newImportPrice = template.ui.$productImportPrice.inputmask('unmaskedvalue')
    return if newName.replace("(", "").replace(")", "").trim().length < 2
    editOptions = splitName(newName)
    editOptions.price = newPrice if newPrice.length > 0
    editOptions.importPrice = newImportPrice if newImportPrice.length > 0

    template.ui.$productName.val editOptions.name
    Session.set "importCurrentProductShowEditCommand", false

    Schema.products.update Session.get("importCurrentProduct")._id, {$set: editOptions}, (error, result) ->
      if error then console.log error else template.ui.$productName.val Session.get("importCurrentProduct").name

  scope.createProduct = (template)->
    fullText    = Session.get("importManagementSearchFilter")
    nameOptions = splitName(fullText)

    product =
      merchant  : Session.get('myProfile').currentMerchant
      warehouse : Session.get('myProfile').currentWarehouse
      creator   : Session.get('myProfile').user
      name      : nameOptions.name
      styles    : Helpers.RandomColor()
    product.skulls = nameOptions.skulls if nameOptions.skulls

    existedQuery = {name: product.name, merchant: product.merchant}
#    existedQuery.skulls = product.skulls if product.skulls
    if Schema.products.findOne(existedQuery)
      console.log 'check'
      template.ui.$searchFilter.notify("Sản phẩm đã tồn tại.", {position: "bottom"})
    else
      while true
        randomBarcode = (Math.floor(Math.random() * 100000000000) + 89 *100000000000).toString()
        existedQuery.productCode = randomBarcode
        if !Schema.products.findOne(existedQuery)
          product.productCode = randomBarcode
          productId = Schema.products.insert  product, (error, result) -> console.log error if error
          Schema.imports.update Session.get('currentImport')._id, $set:{currentProduct: productId}
          template.ui.$searchFilter.val(''); Session.set("importManagementSearchFilter", "")
          break
      MetroSummary.updateMetroSummaryBy(['product'])

  scope.updateImportDetail = (importDetail, template) ->
    currentImport = Session.get("currentImport")
    if currentImport._id is importDetail.import
      unitQuality   = Number(template.ui.$editImportQuality.inputmask('unmaskedvalue'))
      unitPrice     = Number(template.ui.$editImportPrice.inputmask('unmaskedvalue'))

      $expireDate = template.ui.$editExpireDate.inputmask('unmaskedvalue')
      isValidDate = $expireDate.length is 8 and moment($expireDate, 'DD/MM/YYYY').isValid()
      if isValidDate then expireDate = moment($expireDate, 'DD/MM/YYYY')._d else expireDate = undefined

      totalPrice = unitQuality * unitPrice

      setOption =
        unitQuality  : unitQuality
        unitPrice    : unitPrice
        importQuality: unitQuality*importDetail.conversionQuality
        importPrice  : unitPrice/importDetail.conversionQuality
        totalPrice   : totalPrice
      setOption.expire = expireDate if expireDate
      Schema.importDetails.update importDetail._id, $set: setOption

      importTotalPrice = 0
      Schema.importDetails.find({import: importDetail.import}).forEach((detail)-> importTotalPrice += detail.totalPrice)

      if currentImport.deposit < 0 then currentImport.deposit = 0
      Schema.imports.update currentImport._id, $set:{totalPrice: importTotalPrice, debit: importTotalPrice - currentImport.deposit}

  scope.depositOptions =
    reactiveSetter: (val) ->
      if currentImport = Session.get("currentImport")
        Schema.imports.update(currentImport._id, $set:{deposit: val, debit: currentImport.totalPrice - val})
    reactiveValue: -> Session.get("currentImport")?.deposit ? 0
    reactiveMax: -> 99999999999
    reactiveMin: -> 0
    reactiveStep: -> 1000
    others:
      forcestepdivisibility: 'none'

