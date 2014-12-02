logics.customerManagement = {}
Apps.Merchant.customerManagementInit = []
Apps.Merchant.customerManagementReactive = []

Apps.Merchant.customerManagementReactive.push (scope) ->
  if Session.get('allowCreateNewCustomer') then allowCreate = '' else allowCreate = 'disabled'
  scope.allowCreate = allowCreate

  if customer = Session.get("customerManagementCurrentCustomer")
    maxRecords = Session.get("customerManagementDataMaxCurrentRecords")
    countRecords = Schema.customSales.find({buyer: customer._id}).count()
    countRecords += Schema.sales.find({buyer: customer._id}).count() if customer.customSaleModeEnabled is false
    Session.set("showExpandSaleAndCustomSale", (maxRecords is countRecords))


    latestCustomSale = Schema.customSales.findOne({buyer: customer._id}, {sort: {debtDate: -1}})
    if latestCustomSale
      if latestTransaction = Schema.transactions.findOne({latestSale: latestCustomSale._id}, {sort: {debtDate: -1}})
        $("[name=paidDate]").val(moment(latestTransaction.debtDate).format('DDMMYYY'))
      else
        $("[name=paidDate]").val(moment(latestCustomSale.debtDate).format('DDMMYYY'))

  if customerId = Session.get("mySession")?.currentCustomerManagementSelection
    Session.set("customerManagementCurrentCustomer", Schema.customers.findOne(customerId))

#  if Session.get("customerManagementCurrentCustomer")
    #customerManagementData
#    Meteor.subscribe('customerManagementData', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableCustomSaleOf', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableSaleOf', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableReturnOf', Session.get("customerManagementCurrentCustomer")._id)