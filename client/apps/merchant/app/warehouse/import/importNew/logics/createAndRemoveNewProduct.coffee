Apps.Merchant.importInit.push (scope) ->
  logics.import.createNewProduct = (event, template)->
    warehouseId = Session.get('myProfile').currentWarehouse
    productCode = template.find(".productCode").value
    name        = template.find(".name").value
    skulls      = [template.find(".skull").value]

    result = Product.createNew(productCode, name, skulls, null, warehouseId)
    console.log result
    if result.error
      console.log result.error
    else
      template.find(".productCode").value = null
      template.find(".name").value = null
      template.find(".skull").value = null

  logics.import.destroyNewProduct = (productId)->
    result = Product.destroyByCreator(productId)
    if result.error then console.log result.error