splitName = (fullText) ->
  if fullText.indexOf("(") > 0
    namePart    = fullText.substr(0, fullText.indexOf("(")).trim()
    skullsPart    = fullText.substr(fullText.indexOf("(")).replace("(", "").replace(")", "").trim()
    return { name: namePart, skulls: [skullsPart] }
  else
    return { name: fullText }

Apps.Merchant.productManagementInit.push (scope) ->
  scope.editProduct = (template) ->
    newName  = template.ui.$productName.val()
    newPrice = template.ui.$productPrice.inputmask('unmaskedvalue')
    return if newName.replace("(", "").replace(")", "").trim().length < 2
    editOptions = splitName(newName)
    editOptions.price = newPrice if newPrice.length > 0

    template.ui.$productName.val editOptions.name
    Session.set "productManagementShowEditCommand", false

    Schema.products.update Session.get("productManagementCurrentProduct")._id, {$set: editOptions}, (error, result) ->
      if error then console.log error
      else
        template.ui.$productName.val Session.get("productManagementCurrentProduct").name
        Session.set("productManagementShowEditCommand")

  scope.createProduct = (template)->
    fullText    = Session.get("productManagementSearchFilter")
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
          UserSession.set('currentProductManagementSelection', productId)
          template.ui.$searchFilter.val(''); Session.set("productManagementSearchFilter", "")
          break