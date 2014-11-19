logics.customerManager = {}
Apps.Merchant.customerManagerInit = []

Apps.Merchant.customerManagerInit.push (scope) ->
  logics.customerManager.availableCustomers = Customer.insideMerchant(Session.get('myProfile').parentMerchant)
  logics.customerManager.availableCustomerAreas = CustomerArea.insideMerchant(Session.get('myProfile').parentMerchant)
  logics.customerManager.myCreateCustomerAreas = CustomerArea.canDeleteByMe()


logics.customerManager.reactiveRun = ->
  if Session.get('allowCreateNewCustomer') then allowCreate = '' else allowCreate = 'disabled'
  logics.customerManager.allowCreate = allowCreate
