lemon.defineWidget Template.distributorManagementImportDetails,
  receivableClass: -> if @debtBalanceChange >= 0 then 'paid' else 'receive'
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("distributorManagementCurrentDistributor")?.customImportDebt
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]

  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit
  quality: ->
    if @conversionQuality then @unitQuality
    else @importQuality

  totalPrice: ->
    if @conversionQuality then @unitQuality*@unitPrice
    else @importQuality*@importPrice

  importPrice: -> if @conversionQuality then @unitPrice else @importPrice

  disableReturnMode: -> !Session.get('distributorManagementReturnMode')
  showDeleteImport: ->
    lastImportId = Session.get("distributorManagementCurrentDistributor")?.lastImport
    if @_id is lastImportId and @creator is Session.get('myProfile').user
      new Date(@version.createdAt.getFullYear(), @version.createdAt.getMonth(), @version.createdAt.getDate() + 1, @version.createdAt.getHours(), @version.createdAt.getMinutes(), @version.createdAt.getSeconds()) > new Date()

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
            beforeDebtBalance: distributor.customImportDebt + distributor.importDebt
            debtBalanceChange: 0
            latestDebtBalance: distributor.customImportDebt + distributor.importDebt
          returnId = Schema.returns.insert returnOption
          returnOption._id = returnId
          Schema.distributors.update @distributor, $set:{returnImportModeEnabled: true, currentReturn: returnId}

          Session.set('distributorManagementReturnMode', true)
          Session.set('distributorManagementCurrentReturn', returnOption)
          $(".dual-detail .nano").nanoScroller({ scroll: 'bottom' })

    "click .deleteImport": (event, template) ->
      try
        currentImport = @
        if Schema.returns.find({timeLineImport: currentImport._id}).count() > 0 then throw 'Đã trả hàng không thể xóa'
        productDetails = Schema.productDetails.find({import: currentImport._id}).fetch()
        for productDetail in productDetails
          if productDetail.importQuality != productDetail.availableQuality or productDetail.importQuality !=  productDetail.inStockQuality
            throw 'Đã bán hàng khong thể xóa'

        distributorIncOption =
          importDebt: -currentImport.debtBalanceChange
          importTotalCash: -currentImport.debtBalanceChange

        transactions = Schema.transactions.find({latestImport: currentImport._id})
        for transaction in transactions
          distributorIncOption.importPaid = -transaction.debtBalanceChange
          distributorIncOption.importDebt = -(currentImport.debtBalanceChange - transaction.debtBalanceChange)
          Schema.transactions.remove transaction._id

        for productDetail in productDetails
          Schema.productDetails.remove productDetail._id
          console.log productDetail
          Schema.products.update productDetail.product, $inc: {
            totalQuality      : -productDetail.importQuality
            availableQuality  : -productDetail.importQuality
            inStockQuality    : -productDetail.importQuality
          }

        Schema.imports.remove currentImport._id
        Schema.importDetails.find({import: currentImport._id}).forEach((detail)-> Schema.importDetails.remove detail._id)

        lastImport = Schema.imports.findOne({distributor: currentImport.distributor, finish: true, submitted: true}, {sort: {'version.createdAt': -1}})
        if lastImport
          Schema.distributors.update currentImport.distributor, $set: {lastImport: lastImport._id}, $inc: distributorIncOption
        else
          Schema.distributors.update currentImport.distributor, $inc: distributorIncOption

        Meteor.call 'reCalculateMetroSummaryTotalPayableCash'
        Meteor.call 'reCalculateMetroSummary'
      catch error
        console.log error

