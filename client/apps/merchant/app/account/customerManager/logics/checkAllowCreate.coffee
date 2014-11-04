logics.customerManager.checkAllowCreate = (context) ->
  fullName = context.ui.$fullName.val()
  phone = context.ui.$phone.val()

  if fullName.length > 0 and phone.length > 0
    if _.findWhere(Session.get("availableCustomers"), {name: fullName, phone: phone})
      Session.set('allowCreateNewCustomer', false)
    else
      Session.set('allowCreateNewCustomer', true)
  else
    Session.set('allowCreateNewCustomer', false)
