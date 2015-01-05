logics.inventoryManager.updateDescription = (context) ->
  if Session.get("currentInventory")
    if context.ui.$description.val().length > 1
      Schema.inventories.update Session.get("currentInventory")._id, $set:{description: context.ui.$description.val()}
    else
      context.ui.$description.val(Session.get("currentInventory").description)
