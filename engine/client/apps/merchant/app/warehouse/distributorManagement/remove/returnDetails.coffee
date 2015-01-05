#lemon.defineWidget Template.distributorManagementReturnDetails,
#  productName: -> @name ? Schema.products.findOne(@product)?.name
#  returnDetailEditingMode: -> Session.get("distributorManagementReturnDetailEditingRow")?._id is @_id
#  returnDetailEditingData: -> Session.get("distributorManagementReturnDetailEditingRow")
#  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
#  returnDetails: ->
#    returnId = UI._templateInstance().data._id
#    Schema.returnDetails.find {return: returnId}, {sort: {'version.createdAt': 1}}
#
#  crossReturnAvailableQuality: ->
#    currentProduct = Schema.productDetails.find({import: @import, product: @product}).fetch()
#    sameProducts = Schema.returnDetails.find({return: @return, productDetail: @productDetail}).fetch()
#    crossProductQuality = 0
#    currentProductQuality = 0
#    crossProductQuality += item.returnQuality for item in sameProducts
#    currentProductQuality += item.availableQuality for item in currentProduct
#
#    crossAvailable = currentProductQuality - crossProductQuality
#    if crossAvailable < 0
#      crossAvailable = Math.ceil(Math.abs(crossAvailable/@conversionQuality))*(-1)
#    else
#      Math.ceil(Math.abs(crossAvailable/@conversionQuality))
#
#    return {
#      crossAvailable: crossAvailable
#      isValid: crossAvailable > 0
#      invalid: crossAvailable < 0
#      errorClass: if crossAvailable >= 0 then '' else 'errors'
#    }
#
#  events:
#    "click .deleteReturn": (event, template) ->
#      if @allowDelete
#        Schema.returns.remove @_id, (error, result) -> console.log error, result
#        Schema.returnDetails.find({return: @_id}).forEach((detail)->Schema.returnDetails.remove detail._id)
#        Schema.distributors.update @distributor, $set:{returnImportModeEnabled: false}, $unset:{currentReturn: true}
#
#    "click .deleteReturnDetail": (event, template) ->
#      Schema.returnDetails.remove @_id
#      Schema.returns.update @return, $inc:{totalPrice: -@finalPrice, finallyPrice: -@finalPrice}
#
#    "click .edit-detail": ->
#      Session.set("distributorManagementReturnDetailEditingRowId", @_id)
#
#    "click .submitReturn": (event, template) ->
#      try
#        currentReturn = @
#        returnDetails = Schema.returnDetails.find({return: currentReturn._id}).fetch()
#        (if detail.returnQuality is 0 then throw 'So luong lon hon 0.') for detail in returnDetails
#
#
#        totalReturnQuality = 0
#        totalReturnPrice = 0
#        for item in returnDetails
#          totalReturnQuality += item.returnQuality
#          totalReturnPrice += item.finalPrice
#
#        returnDetails = _.chain(returnDetails)
#        .groupBy("product")
#        .map (group, key) ->
#          return {
#          product: key
#          quality: _.reduce(group, ((res, current) -> res + current.returnQuality), 0)
#          }
#        .value()
#
#        for returnDetail in returnDetails
#          quality = 0
#          Schema.productDetails.find({
#            import: currentReturn.import
#            product: returnDetail.product
#            availableQuality: {$gt:0}
#          }).forEach((productDetail)-> quality += productDetail.availableQuality)
#          if quality < returnDetail.quality then throw 'So luong khong du.'
#
#
#        for returnDetail in returnDetails
#          productDetails = Schema.productDetails.find({
#            import: currentReturn.import
#            product: returnDetail.product
#            availableQuality: {$gt:0}
#          }).fetch()
#
#          transactionQuality = 0
#          for productDetail in productDetails
#            requiredQuality = returnDetail.quality - transactionQuality
#            if productDetail.availableQuality > requiredQuality then takenQuality = requiredQuality
#            else takenQuality = productDetail.availableQuality
#
#            Schema.productDetails.update productDetail._id, $inc:{
#              availableQuality: -takenQuality
#              inStockQuality: -takenQuality
#              importPrice: -takenQuality
#            }
#            Schema.products.update productDetail.product  , $inc:{
#              availableQuality: -takenQuality
#              inStockQuality: -takenQuality
#              totalQuality: -takenQuality
#            }
#
#            transactionQuality += takenQuality
#            if transactionQuality == returnDetail.quality then break
#
#        Schema.distributors.update currentReturn.distributor
#        , $set:{returnImportModeEnabled: false}
#        , $unset:{currentReturn: true}
#        , $inc:{importTotalCash: -totalReturnPrice, importDebt: -totalReturnPrice}
#
#        console.log currentReturn
#        timeLineImport = Schema.imports.findOne({distributor: currentReturn.distributor, finish: true, submitted: true}, {sort: {'version.createdAt': -1}})
#        Schema.returns.update currentReturn._id, $set: {timeLineImport: timeLineImport._id, status: 2, 'version.createdAt': new Date(), allowDelete: false}
#        #update Metrosummary(so luong san pham mat di)
#
#        #cap nhat tien phai tra
#        Meteor.call 'reCalculateMetroSummaryTotalPayableCash'
#      catch error
#        console.log error