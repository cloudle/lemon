logics.inventoryManager.checkAllowCreate = (context) ->
  description = context.ui.$description.val()
  if description.length > 1
    Session.set('allowCreateNewInventory', true)
  else
    Session.set('allowCreateNewInventory', false)
