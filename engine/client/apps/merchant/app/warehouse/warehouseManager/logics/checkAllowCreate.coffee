logics.warehouseManager.checkAllowCreate = (context) ->
  name = context.ui.$name.val()

  if name.length > 0
    Session.set('allowCreateNewWarehouse', true)
  else
    Session.set('allowCreateNewWarehouse', false)