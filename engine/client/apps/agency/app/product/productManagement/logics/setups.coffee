Apps.Agency.agencyProductManagementInit.push (scope) ->
  scope.updateBasicProductDetail = (productDetailId, template)->
    if productDetail = Schema.productDetails.findOne(productDetailId)
      $paidDate = $("[name='expireDate']").inputmask('unmaskedvalue')
      isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid()
      if isValidDate then expireDate = moment($paidDate, 'DDMMYYYY')._d

      unitQuality = Helpers.Number(template.ui.$unitQuality.inputmask('unmaskedvalue'))
      unitQuality = 1 if unitQuality < 0

      unitImportPrice = Helpers.Number(template.ui.$importPrice.inputmask('unmaskedvalue'))
      unitImportPrice = 0 if unitImportPrice < 0

      detailOption =
        unitQuality       : unitQuality
        unitPrice         : unitImportPrice
        importPrice       : if unitImportPrice is 0 then 0 else unitImportPrice/productDetail.conversionQuality
        importQuality     : unitQuality * productDetail.conversionQuality
        availableQuality  : unitQuality * productDetail.conversionQuality
        inStockQuality    : unitQuality * productDetail.conversionQuality
      detailOption.expire = expireDate if expireDate
      Schema.productDetails.update productDetail._id, $set: detailOption

      productUpdate =
        totalQuality    : detailOption.importQuality - productDetail.importQuality
        availableQuality: detailOption.availableQuality - productDetail.availableQuality
        inStockQuality  : detailOption.inStockQuality - productDetail.inStockQuality
      Schema.branchProductSummaries.update productDetail.branchProduct, $inc:productUpdate
      Schema.products.update productDetail.product, $inc:productUpdate

  #    metroSummary = Schema.metroSummaries.findOne({merchant: Session.get('myProfile').currentMerchant})
  #    Schema.metroSummaries.update metroSummary._id, $inc:{
  #      stockProductCount: unitQuality * productDetail.conversionQuality - productDetail.importQuality
  #      availableProductCount: unitQuality * productDetail.conversionQuality - productDetail.importQuality
  #    }

  scope.addBasicProductDetail = (currentProduct, product, branchProductSummary, profile) ->
    if profile and product and branchProductSummary
      detailOption =
        parentMerchant    : product.parentMerchant
        merchant          : product.merchant
        warehouse         : product.warehouse
        product           : product._id
        branchProduct     : branchProductSummary._id

      if currentProduct._id is product._id
        detailOption.unitPrice         = product.importPrice ? 0
        detailOption.importPrice       = product.importPrice ? 0
        detailOption.unitQuality       = 1
        detailOption.conversionQuality = 1
        detailOption.importQuality     = 1
        detailOption.availableQuality  = 1
        detailOption.inStockQuality    = 1
      else
        if productUnit = Schema.productUnits.findOne({_id: currentProduct._id, product: product._id})
          branchProductUnit = Schema.branchProductUnits.findOne({productUnit: productUnit._id, merchant: profile.currentMerchant})
          buildInProductUnit = Schema.buildInProductUnits.findOne(productUnit.buildInProductUnit) if productUnit.buildInProductUnit
          
          productImportPrice =  branchProductUnit.importPrice ? productUnit.importPrice ? buildInProductUnit.importPrice
          conversionQuality  =  branchProductUnit.conversionQuality ? productUnit.conversionQuality ? buildInProductUnit.conversionQuality

          detailOption.unitPrice         = productImportPrice
          detailOption.importPrice       = productImportPrice
          detailOption.unitQuality       = 1
          detailOption.unit              = productUnit._id
          detailOption.conversionQuality = conversionQuality
          detailOption.importQuality     = conversionQuality
          detailOption.availableQuality  = conversionQuality
          detailOption.inStockQuality    = conversionQuality

      if detailOption
        productDetailId = Schema.productDetails.insert detailOption
        if Schema.productDetails.findOne(productDetailId)
          Schema.products.update product._id, $set:{allowDelete: false}, $inc:{
            totalQuality    : detailOption.importQuality
            availableQuality: detailOption.importQuality
            inStockQuality  : detailOption.importQuality
          }
          Schema.branchProductSummaries.update branchProductSummary._id, $inc:{
            totalQuality    : detailOption.importQuality
            availableQuality: detailOption.importQuality
            inStockQuality  : detailOption.importQuality
          }

          Schema.productUnits.update detailOption.unit, $set:{allowDelete: false} if detailOption.unit
          metroSummary = Schema.metroSummaries.findOne({merchant: profile.currentMerchant})
          Schema.metroSummaries.update metroSummary._id, $inc:{
            stockProductCount: detailOption.importQuality
            availableProductCount: detailOption.importQuality
          }

  scope.checkValidEditProduct = (template) ->
    Session.set scope.agencyProductManagementProductEditCommand,
      template.ui.$productName.val() isnt Session.get(scope.agencyProductManagementCurrentProduct).name or
      template.ui.$productPrice.inputmask('unmaskedvalue') isnt (Session.get(scope.agencyProductManagementCurrentProduct).price ? '') or
      template.ui.$importPrice.inputmask('unmaskedvalue') isnt (Session.get(scope.agencyProductManagementCurrentProduct).importPrice ? '') or
      template.ui.$productCode.val() isnt Session.get(scope.agencyProductManagementCurrentProduct).productCode

  scope.checkValidAndUpdateProduct = (event, template) ->
    if event.which is 27
      if $(event.currentTarget).attr('name') is 'productName'
        $(event.currentTarget).val(Session.get(scope.agencyProductManagementCurrentProduct).name)
        $(event.currentTarget).change()
      else if $(event.currentTarget).attr('name') is 'productPrice'
        $(event.currentTarget).val(Session.get(scope.agencyProductManagementCurrentProduct).price)
      else if $(event.currentTarget).attr('name') is 'importPrice'
        $(event.currentTarget).val(Session.get(scope.agencyProductManagementCurrentProduct).importPrice)
      else if $(event.currentTarget).attr('name') is 'productCode'
        $(event.currentTarget).val(Session.get(scope.agencyProductManagementCurrentProduct).productCode)
    else if event.which is 13 and Session.get scope.agencyProductManagementProductEditCommand
      scope.editProduct(template)

  scope.deleteBasicProductDetail = (product, productDetail, branchProductSummary, profile) ->
    if product and productDetail and profile
      if productDetail.allowDelete and product.basicDetailModeEnabled
        Schema.productDetails.remove(productDetail._id)
        if !Schema.productDetails.findOne({unit: productDetail.unit}) then Schema.productUnits.update productDetail.unit, $set:{allowDelete: true}

        Schema.products.update product._id, $set:{allowDelete: false}, $inc:{
          totalQuality    : -productDetail.importQuality
          availableQuality: -productDetail.importQuality
          inStockQuality  : -productDetail.importQuality
        }
        Schema.branchProductSummaries.update branchProductSummary._id, $inc:{
          totalQuality    : -productDetail.importQuality
          availableQuality: -productDetail.importQuality
          inStockQuality  : -productDetail.importQuality
        }

        metroSummary = Schema.metroSummaries.findOne({merchant: profile.currentMerchant})
        Schema.metroSummaries.update metroSummary._id, $inc:{
          stockProductCount: -productDetail.importQuality
          availableProductCount: -productDetail.importQuality
        }


  scope.addGeraProduct = (product)->