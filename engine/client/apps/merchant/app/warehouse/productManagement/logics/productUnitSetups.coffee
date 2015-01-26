Apps.Merchant.productManagementInit.push (scope) ->
  scope.createProductUnit = (product, profile) ->
    #TODO: Chinh lai truong hop bi trung randomBarcode()
    if !product.buildInProduct and product.basicUnit and profile
      productUnit =
        parentMerchant   : product.parentMerchant
        merchant         : profile.currentMerchant
        createMerchant   : profile.currentMerchant
        creator          : profile.user
        product          : product._id
        productCode      : Helpers.randomBarcode()
        price            : 0
        importPrice      : 0
        conversionQuality: 1
      Meteor.call 'createProductUnitBy', productUnit, (error, result) ->
        if error then console.log error.error
        else Session.set("productManagementUnitEditingRowId", result) if result

  scope.updateProductUnit = (template, productUnit, branchProductUnit) ->
    if template and productUnit and branchProductUnit
      price       = Math.abs(Helpers.Number(template.ui.$price.inputmask('unmaskedvalue')))
      importPrice = Math.abs(Helpers.Number(template.ui.$importPrice.inputmask('unmaskedvalue')))
      unitOption = {price: price, importPrice: importPrice}

      if !productUnit.buildInProductUnit and (productUnit.merchant is productUnit.createMerchant or productUnit.merchant is productUnit.parentMerchant)
        unit    = template.ui.$unit.val()
        barcode = template.ui.$barcode.val()
        unitOption.unit        = unit if unit.length > 0
        unitOption.productCode = barcode if barcode.length > 0

        if productUnit.allowDelete
          conversionQuality = Math.abs(Helpers.Number(template.ui.$conversionQuality.inputmask('unmaskedvalue')))
          conversionQuality = 1 if conversionQuality < 1
        unitOption.conversionQuality = conversionQuality if conversionQuality

      if productUnit.merchant is productUnit.createMerchant or productUnit.merchant is productUnit.parentMerchant
        Schema.productUnits.update productUnit._id, $set: unitOption
        Schema.branchProductUnits.update branchProductUnit._id, $unset: {price: "", importPrice: ""s}
      else
        Schema.branchProductUnits.update branchProductUnit._id, $set: {price: price, importPrice: importPrice}

  scope.deleteProductUnit = (productUnit) ->
    if productUnit.merchant is productUnit.createMerchant
      Meteor.call 'deleteProductUnit', productUnit, (error, result) ->
        if error then console.log error.error
        else Session.set("productManagementUnitEditingRowId", result) if result

