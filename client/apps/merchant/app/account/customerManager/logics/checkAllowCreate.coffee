logics.customerManager.checkAllowCreate = (context) ->
  fullName = context.ui.$fullName.val()
  description = context.ui.$description.val()

  if fullName.length > 0 #and description.length > 0
    option =
      name: fullName
      description: description if description.length > 0

    if _.findWhere(Session.get("availableCustomers"), option)
      Session.set('allowCreateNewCustomer', false)
    else
      Session.set('allowCreateNewCustomer', true)
  else
    Session.set('allowCreateNewCustomer', false)
