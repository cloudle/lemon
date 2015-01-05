lemon.defineWidget Template.distributorManagementImportDetails,
  receivableClass: -> if @debtBalanceChange >= 0 then 'paid' else 'receive'
  productName: -> @name ? Schema.products.findOne(@product)?.name
  totalDebtBalance: -> @latestDebtBalance + Session.get("distributorManagementCurrentDistributor")?.customImportDebt
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]

  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit
  quality: -> if @conversionQuality then @unitQuality else @importQuality
  totalPrice: -> if @conversionQuality then @unitQuality*@unitPrice else @importQuality*@importPrice
  importPrice: -> if @conversionQuality then @unitPrice else @importPrice

  showDeleteImport: ->
    if @creator is Session.get('myProfile').user
      new Date(@version.createdAt.getFullYear(), @version.createdAt.getMonth(), @version.createdAt.getDate() + 1, @version.createdAt.getHours(), @version.createdAt.getMinutes(), @version.createdAt.getSeconds()) > new Date()

  showDeleteTransaction: -> new Date(@debtDate.getFullYear(), @debtDate.getMonth(), @debtDate.getDate() + 1, @debtDate.getHours(), @debtDate.getMinutes(), @debtDate.getSeconds()) > new Date()


  importDetailCount: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find({import: importId}, {sort: {'version.createdAt': 1}}).count()


  importDetails: ->
    importId = UI._templateInstance().data._id
    Schema.productDetails.find {import: importId}, {sort: {'version.createdAt': 1}}

  latestPaids: -> Schema.transactions.find({latestImport: @_id})
  returns: -> Schema.returns.find({timeLineImport: @_id})
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
