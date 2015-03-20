lemon.defineWidget Template.customerManagementSaleDetails,
  skulls: -> Schema.products.findOne(@product)?.skulls?[0]
  unitSaleQuality: -> Math.round(@quality/@conversionQuality*100)/100
  totalDebtBalance: -> @latestDebtBalance + Session.get("customerManagementCurrentCustomer")?.customSaleDebt
  receivableClass: -> if @debtBalanceChange >= 0 then 'receive' else 'paid'
  finalReceivableClass: ->
    latestDebtBalance = @latestDebtBalance + Session.get("customerManagementCurrentCustomer")?.customSaleDebt
    if latestDebtBalance >= 0 then 'receive' else 'paid'

  isShowDeleteTransaction: ->
    year = @debtDate.getFullYear(); mount = @debtDate.getMonth(); date = @debtDate.getDate()
    hour = @debtDate.getHours(); minute = @debtDate.getMinutes(); second = @debtDate.getSeconds()
    new Date(year, mount, date + 1, hour, minute, second) > new Date()

  showDeleteSales: ->
    time = @version.createdAt
    if @creator is Session.get('myProfile').user and @paymentsDelivery is 0 and !Schema.returns.findOne({timeLineSales: @_id})
      checkDate   = new Date(time.getFullYear(), time.getMonth(), time.getDate() + 1, time.getHours(), time.getMinutes(), time.getSeconds()) > new Date()
      checkReturn = if Schema.saleDetails.findOne({sale: @_id, returnQuality: {$gt: 0}}) then false else true
      checkDate and checkReturn


  saleDetailCount: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find({sale: saleId}, {sort: {'version.createdAt': 1}}).count() > 0

  saleDetails: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find {sale: saleId}, {sort: {'version.createdAt': 1}}

  dependsData: ->
    transactions = Schema.transactions.find({latestSale: @_id}).fetch()
    returns = Schema.returns.find({timeLineSales: @_id}).fetch()
    dependsData = _.sortBy transactions.concat(returns), (item) -> if item.debtDate then item.version.updateAt = item.debtDate
    _.sortBy dependsData, (item) -> item.version.updateAt

  returnDetails: -> Schema.returnDetails.find({return: @_id})

  events:
    "click .deleteSales": (event, template) ->
      Meteor.call 'customerManagementDeleteSale', @_id, (error, result) -> if error then console.log error
      Meteor.call 'reCalculateMetroSummaryTotalReceivableCash', (error, result) -> if error then console.log error
      Meteor.call 'reCalculateMetroSummary', (error, result) -> if error then console.log error

    "click .deleteTransaction": (event, template) ->
      Meteor.call 'customerManagementDeleteTransaction', @_id, (error, result) -> if error then console.log error
      Meteor.call 'reCalculateMetroSummaryTotalReceivableCash', (error, result) -> if error then console.log error
      Meteor.call 'reCalculateMetroSummary', (error, result) -> if error then console.log error