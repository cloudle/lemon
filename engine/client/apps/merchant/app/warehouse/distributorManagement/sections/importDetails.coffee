lemon.defineWidget Template.distributorManagementImportDetails,
  receivableClass: -> if @debtBalanceChange >= 0 then 'paid' else 'receive'
  finalReceivableClass: ->
    latestDebtBalance = @latestDebtBalance + Session.get("distributorManagementCurrentDistributor")?.customImportDebt
    if latestDebtBalance >= 0 then 'receive' else 'paid'
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("distributorManagementCurrentDistributor")?.customImportDebt
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]

  quality: -> if @conversionQuality then @unitQuality else @importQuality
  totalPrice: -> if @conversionQuality then @unitQuality*@unitPrice else @importQuality*@importPrice
  importPrice: -> if @conversionQuality then @unitPrice else @importPrice

  showDeleteImport: ->
    if @creator is Session.get('myProfile').user
      createDate = new Date(@version.createdAt.getFullYear(), @version.createdAt.getMonth(), @version.createdAt.getDate() + 1, @version.createdAt.getHours(), @version.createdAt.getMinutes(), @version.createdAt.getSeconds())
      createDate > new Date() and !Schema.returns.findOne({timeLineImport: @_id})

  showDeleteTransaction: -> new Date(@debtDate.getFullYear(), @debtDate.getMonth(), @debtDate.getDate() + 1, @debtDate.getHours(), @debtDate.getMinutes(), @debtDate.getSeconds()) > new Date()


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
