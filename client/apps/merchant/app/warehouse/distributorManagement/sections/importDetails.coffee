lemon.defineWidget Template.distributorManagementImportDetails,
  receivableClass: -> if @debtBalanceChange >= 0 then 'paid' else 'receive'
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("distributorManagementCurrentDistributor")?.customImportDebt
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]

  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit

  quality: -> @availableQuality/@conversionQuality ?  @availableQuality
  disableReturnMode: -> !Session.get('distributorManagementReturnMode')
  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find {import: importId}, {sort: {'version.createdAt': 1}}

  latestPaids: -> Schema.transactions.find({latestImport: @_id})
  returns: -> Schema.returns.find({timeLineImport: @_id})
  returnDetails: -> Schema.returnDetails.find({return: @_id})


  events:
    "click .createReturnProduct": (event, template) ->
      if distributor = Session.get("distributorManagementCurrentDistributor")
        if distributor.returnImportModeEnabled is false and distributor.currentReturn is undefined
          returnOption =
            merchant        : Session.get('myProfile').currentMerchant
            warehouse       : Session.get('myProfile').currentWarehouse
            creator         : Session.get('myProfile').user
            returnCode      : 'TH'
            import          : @_id
            distributor     : @distributor
            discountCash    : 0
            discountPercent : 0
            totalPrice      : 0
            finallyPrice    : 0
            status          : 0
            comment         : "Trả hàng cho nhà cung cấp"
          returnId = Schema.returns.insert returnOption
          returnOption._id = returnId
          Schema.distributors.update @distributor, $set:{returnImportModeEnabled: true, currentReturn: returnId}

          Session.set('distributorManagementReturnMode', true)
          Session.set('distributorManagementCurrentReturn', returnOption)
          $(".dual-detail .nano").nanoScroller({ scroll: 'bottom' })