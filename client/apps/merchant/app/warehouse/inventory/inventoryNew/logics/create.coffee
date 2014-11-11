logics.inventoryManager.createNewInventory = (event, template)->
  description = template.ui.$description
  if description.val().length > 1
    Meteor.call 'createNewInventory', Session.get('mySession').currentImportWarehouse, description.val(), (error, result) ->
      if error then console.log error
      else Session.set('allowCreateNewInventory', false)