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
    if @creator is Session.get('myProfile').user and @paymentsDelivery is 0 and !Schema.returns.findOne({timeLineSales: @_id})
      new Date(@version.createdAt.getFullYear(), @version.createdAt.getMonth(), @version.createdAt.getDate() + 1, @version.createdAt.getHours(), @version.createdAt.getMinutes(), @version.createdAt.getSeconds()) > new Date()


  saleDetailCount: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find({sale: saleId}, {sort: {'version.createdAt': 1}}).count() > 0

  saleDetails: ->
    saleId = UI._templateInstance().data._id
    Schema.saleDetails.find {sale: saleId}, {sort: {'version.createdAt': 1}}

  dependsData: ->
    transactions = Schema.transactions.find({latestSale: @_id}).fetch()
    returns = Schema.returns.find({timeLineSales: @_id}).fetch()
    _.sortBy transactions.concat(returns), (item) -> item.version.createdAt

  returnDetails: -> Schema.returnDetails.find({return: @_id})

  events:
    "click .deleteSales": (event, template) ->
      Meteor.call 'customerManagementDeleteSale', @_id
      Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'
      Meteor.call 'reCalculateMetroSummary'

    "click .deleteTransaction": (event, template) ->
      Meteor.call 'customerManagementDeleteTransaction', @_id
      Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'
      Meteor.call 'reCalculateMetroSummary'