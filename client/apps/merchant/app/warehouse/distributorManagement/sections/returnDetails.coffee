lemon.defineWidget Template.distributorManagementReturnDetails,
  productName: -> @name ? Schema.products.findOne(@product)?.name
  returnDetailEditingMode: -> Session.get("distributorManagementReturnDetailEditingRow")?._id is @_id
  returnDetailEditingData: -> Session.get("distributorManagementReturnDetailEditingRow")
  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
  returnDetails: ->
    returnId = UI._templateInstance().data._id
    Schema.returnDetails.find {return: returnId}, {sort: {'version.createdAt': 1}}

  crossReturnAvailableQuality: ->
    currentProduct = Schema.productDetails.findOne(@productDetail)
    sameProducts = Schema.returnDetails.find({return: @return, productDetail: @productDetail}).fetch()
    crossProductQuality = 0
    crossProductQuality += item.returnQuality for item in sameProducts
    cross =
      product: currentProduct
      quality: crossProductQuality

    crossAvailable = cross.product.availableQuality - cross.quality
    if crossAvailable < 0
      crossAvailable = Math.ceil(Math.abs(crossAvailable/@conversionQuality))*(-1)
    else
      Math.ceil(Math.abs(crossAvailable/@conversionQuality))

    return {
      crossAvailable: crossAvailable
      isValid: crossAvailable > 0
      invalid: crossAvailable < 0
      errorClass: if crossAvailable >= 0 then '' else 'errors'
    }

  events:
    "click .deleteReturn": (event, template) ->
      if @allowDelete
        Schema.returns.remove @_id, (error, result) -> console.log error, result
        Schema.returnDetails.find({return: @_id}).forEach((detail)->Schema.returnDetails.remove detail._id)
        Schema.distributors.update @distributor, $set:{returnImportModeEnabled: false}, $unset:{currentReturn: true}

    "click .deleteReturnDetail": (event, template) ->
      Schema.returnDetails.remove @_id
      Schema.returns.update @return, $inc:{totalPrice: -@finalPrice, finallyPrice: -@finalPrice}

    "click .edit-detail": ->
      Session.set("distributorManagementReturnDetailEditingRowId", @_id)

    "click .submitReturn": (event, template) ->
      try
        currentReturn = @
        returnDetails = Schema.returnDetails.find({return: currentReturn._id}).fetch()
        (if detail.returnQuality is 0 then throw 'So luong lon hon 0.') for detail in returnDetails

        productDetailIds = _.uniq(_.pluck(returnDetails, 'productDetail'))
        productDetails = Schema.productDetails.find({_id:{$in: productDetailIds}}).fetch()

        for productDetail in productDetails
          returnDetails = _.where(returnDetails, {productDetail: productDetail._id})
          crossProductQuality = 0
          crossProductQuality += item.returnQuality for item in returnDetails
          crossAvailable = productDetail.availableQuality - crossProductQuality
          if crossAvailable < 0 then throw 'So luong khong du'

        for productDetail in productDetails
          totalReturnQuality = 0
          totalReturnPrice = 0
          returnDetails = _.where(returnDetails, {productDetail: productDetail._id})

          for item in returnDetails
            totalReturnQuality += item.returnQuality
            totalReturnPrice += item.finalPrice

          optionProduct =
            importQuality   : -totalReturnQuality
            availableQuality: -totalReturnQuality
            inStockQuality  : -totalReturnQuality

          Schema.productDetails.update productDetail._id, $inc: optionProduct
          Schema.products.update productDetail.product, $inc: optionProduct, $inc: optionProduct
          Schema.distributors.update productDetail.distributor
          , $set:{returnImportModeEnabled: false}
          , $unset:{currentReturn: true}
          , $inc:{importTotalCash: -totalReturnPrice, importDebt: -totalReturnPrice}

        timeLineImport = Schema.imports.findOne({distributor: productDetail.distributor, finish: true, submitted: true}, {sort: {'version.createdAt': -1}})
        Schema.returns.update currentReturn._id, $set: {timeLineImport: timeLineImport._id, status: 2, 'version.createdAt': new Date(), allowDelete: false}
        #update Metrosummary(so luong san pham mat di)
      catch error
        console.log error




