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

#  if customerId = Session.get("mySession")?.currentCustomerManagementSelection
#    Session.set("customerManagementCurrentCustomer", Schema.customers.findOne(customerId))

#  if Session.get("customerManagementCurrentCustomer")
    #customerManagementData
#    Meteor.subscribe('customerManagementData', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableCustomSaleOf', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableSaleOf', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableReturnOf', Session.get("customerManagementCurrentCustomer")._id)