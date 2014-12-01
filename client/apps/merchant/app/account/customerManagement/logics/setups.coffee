Apps.Merchant.customerManagementInit.push (scope) ->
  Session.set("customerManagementSearchFilter", "")

  if !Session.get("mySession").currentCustomerManagementSelection
    if customer = Schema.customers.findOne()
      UserSession.set("currentCustomerManagementSelection", customer._id)
      Meteor.subscribe('customerManagementData', customer._id)
  else
    Meteor.subscribe('customerManagementData', Session.get("mySession").currentCustomerManagementSelection)

  scope.checkAllowCreate = (context) ->
    fullName = context.ui.$fullName.val()
    description = context.ui.$description.val()
    if fullName.length > 0
      option =
        name: fullName
        description: description if description.length > 0
      if _.findWhere(Session.get("availableCustomers"), option) then Session.set('allowCreateNewCustomer', false)
      else Session.set('allowCreateNewCustomer', true)
    else Session.set('allowCreateNewCustomer', false)
