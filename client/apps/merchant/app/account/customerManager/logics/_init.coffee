logics.customerManager = {}
Apps.Merchant.customerManagerInit = []

Apps.Merchant.customerManagerInit.push (scope) ->
  logics.customerManager.availableCustomers = Customer.insideMerchant(Session.get('myProfile').parentMerchant)


logics.customerManager.reactiveRun = ->
  if Session.get('allowCreateNewCustomer')
    logics.customerManager.allowCreate = ''
  else
    logics.customerManager.allowCreate = 'disabled'
