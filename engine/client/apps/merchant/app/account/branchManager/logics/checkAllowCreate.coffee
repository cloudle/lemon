logics.branchManager.checkAllowCreate = (context) ->
  name = context.ui.$name.val()
  if name.length > 0
    if _.findWhere(Session.get("availableMerchant"), {name: name})
      Session.set('allowCreateNewBranch', false)
    else
      Session.set('allowCreateNewBranch', true)
  else
    Session.set('allowCreateNewBranch', false)