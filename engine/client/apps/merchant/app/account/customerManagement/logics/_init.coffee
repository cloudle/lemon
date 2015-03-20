logics.customerManagement = {}
Apps.Merchant.customerManagementInit = []
Apps.Merchant.customerManagementReactive = []

Apps.Merchant.customerManagementReactive.push (scope) ->
#  allowCreate = if Session.get('allowCreateNewCustomer') then '' else 'disabled'
#  scope.allowCreate = allowCreate

  if customerId = Session.get("mySession")?.currentCustomerManagementSelection
    Session.set("customerManagementCurrentCustomer", Schema.customers.findOne(customerId))

  if customer = Session.get("customerManagementCurrentCustomer")
    maxRecords = Session.get("customerManagementDataMaxCurrentRecords")
    countRecords = Schema.customSales.find({buyer: customer._id}).count()
    countRecords += Schema.sales.find({buyer: customer._id}).count() if customer.customSaleModeEnabled is false
    Session.set("showExpandSaleAndCustomSale", (maxRecords is countRecords))


    if latestCustomSale = Schema.customSales.findOne({buyer: customer._id}, {sort: {debtDate: -1}})
      if latestTransaction = Schema.transactions.findOne({latestSale: latestCustomSale._id}, {sort: {debtDate: -1}})
        $("[name=paidDate]").val(moment(latestTransaction.debtDate).format('DDMMYYYY'))
      else
        $("[name=paidDate]").val(moment(latestCustomSale.debtDate).format('DDMMYYYY'))
      $("[name=debtDate]").val(moment(latestCustomSale.debtDate).format('DDMMYYYY'))
    else
      $("[name=paidDate]").val('')
      $("[name=debtDate]").val('')


#    if latestSale = Schema.sales.findOne({buyer: customer._id}, {sort: {'version.createdAt': -1}})
#      if latestTransaction = Schema.transactions.findOne({latestSale: latestSale._id}, {sort: {debtDate: -1}})
#        $("[name=paidSaleDate]").val(moment(latestTransaction.debtDate).format('DDMMYYY'))
#      else
#        $("[name=paidSaleDate]").val(moment(latestSale.version.createdAt).format('DDMMYYY'))
#    else
#      $("[name=paidSaleDate]").val('')

#  if Session.get("customerManagementCurrentCustomer")
    #customerManagementData
#    Meteor.subscribe('customerManagementData', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableCustomSaleOf', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableSaleOf', Session.get("customerManagementCurrentCustomer")._id)
#    Meteor.subscribe('availableReturnOf', Session.get("customerManagementCurrentCustomer")._id)