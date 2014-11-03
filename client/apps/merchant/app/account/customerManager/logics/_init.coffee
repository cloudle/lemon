logics.customerManager = {}
Apps.Merchant.customerManagerInit = []

Apps.Merchant.customerManagerInit.push (scope) ->
  logics.customerManager.availableCustomers = Customer.insideMerchant(Session.get('myProfile').parentMerchant)


logics.customerManager.reactiveRun = ->
  if Session.get('allowCreateNewCustomer')
    logics.customerManager.allowCreate = 'btn-success'
  else
    logics.customerManager.allowCreate = 'btn-default disabled'
