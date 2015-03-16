lemon.defineWidget Template.distributorManagementImportDetails,
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]
  quality: -> if @conversionQuality then @unitQuality else @importQuality
  totalPrice: -> if @conversionQuality then @unitQuality*@unitPrice else @importQuality*@importPrice
  importPrice: -> if @conversionQuality then @unitPrice else @importPrice
  totalDebtBalance: -> @latestDebtBalance + Session.get("distributorManagementCurrentDistributor")?.customImportDebt

  receivableClass: -> if @debtBalanceChange >= 0 then 'paid' else 'receive'
  finalReceivableClass: ->
    latestDebtBalance = @latestDebtBalance + Session.get("distributorManagementCurrentDistributor")?.customImportDebt
    if latestDebtBalance >= 0 then 'receive' else 'paid'


  showDeleteImport: ->
    if @creator is Session.get('myProfile').user
      year = @version.createdAt.getFullYear(); mount = @version.createdAt.getMonth(); date = @version.createdAt.getDate()
      hour = @version.createdAt.getHours(); minute = @version.createdAt.getMinutes(); second = @version.createdAt.getSeconds()
      if checkDay = new Date(year, mount, date + 1, hour, minute, second) > new Date()
        checkReturn = if Schema.returns.findOne({timeLineImport: @_id}) then false else true
        checkSale = true; Schema.productDetails.find({import: @_id}).forEach(
          (productDetail) -> checkSale = false if productDetail.importQuality isnt productDetail.availableQuality
        )
      checkDay and checkReturn and checkSale

  showDeleteTransaction: ->
    year = @debtDate.getFullYear(); mount = @debtDate.getMonth(); date = @debtDate.getDate()
    hour = @debtDate.getHours(); minute = @debtDate.getMinutes(); second = @debtDate.getSeconds()
    new Date(year, mount, date + 1, hour, minute, second) > new Date()

  importDetailCount: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find({import: importId}, {sort: {'version.createdAt': 1}}).count()

  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find {import: importId}, {sort: {'version.createdAt': 1}}

  dependsData: ->
    transactions = Schema.transactions.find({latestImport: @_id}).fetch()
    returns = Schema.returns.find({timeLineImport: @_id}).fetch()
    _.sortBy transactions.concat(returns), (item) -> item.version.createdAt

  returnDetails: -> Schema.returnDetails.find({return: @_id})

  events:
    "click .deleteImport": (event, template) ->
      Meteor.call 'distributorManagementDeleteImport', @_id
      Meteor.call 'reCalculateMetroSummaryTotalPayableCash'
      Meteor.call 'reCalculateMetroSummary'

    "click .deleteTransaction": (event, template) ->
      Meteor.call 'distributorManagementDeleteTransaction', @_id
      Meteor.call 'reCalculateMetroSummaryTotalPayableCash'
      Meteor.call 'reCalculateMetroSummary'
