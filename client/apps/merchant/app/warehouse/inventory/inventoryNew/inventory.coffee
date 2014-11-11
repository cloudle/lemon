lemon.defineApp Template.inventory,
  rendered: -> logics.inventoryManager.templateInstance = @
  events:
    "click .inventoryHistory": (event, template) -> Router.go('/inventoryHistory')
    "input input": (event, template) -> logics.inventoryManager.checkAllowCreate(template)
    'blur input': (event, template)-> logics.inventoryManager.updateDescription(template)

    "change [name='advancedMode']": (event, template) ->
      logics.inventoryManager.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    'click .createInventory': (event, template)->
      logics.inventoryManager.createNewInventory(event, template)

    'click .destroyInventory': (event, template)->
      logics.inventoryManager.destroyInventory(logics.inventoryManager.currentWarehouse._id)

    'click .submitInventory': (event, template)->
      console.log logics.inventoryManager.successInventory(logics.inventoryManager.currentWarehouse._id)
