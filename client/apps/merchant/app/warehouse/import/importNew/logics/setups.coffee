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

    existedQuery = {name: product.name, currentMerchant: Session.get('myProfile').currentMerchant}
    existedQuery.skulls = product.skulls if product.skulls
    if Schema.products.findOne(existedQuery)
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