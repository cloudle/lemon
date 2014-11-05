lemon.defineApp Template.inventory,
  created: ->
  rendered: ->
    logics.inventoryManager.templateInstance = @

  events:
    "input input": (event, template) -> logics.inventoryManager.checkAllowCreate(template)
    'blur input': (event, template)-> logics.inventoryManager.updateDescription(template)

    "change [name='advancedMode']": (event, template) ->
      logics.inventoryManager.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked


    'click .createInventory': (event, template)->
      description = template.ui.$description
      if description.val().length > 1
        Meteor.call 'createNewInventory', Session.get('mySession').currentWarehouse, description.val(), (error, result) ->
          if error then console.log error
          else Session.set('allowCreateNewInventory', false)

    'click .destroyInventory': (event, template)->
      logics.inventoryManager.destroyInventory(logics.inventoryManager.currentWarehouse._id)


    'click .submitInventory': (event, template)->
      console.log logics.inventoryManager.successInventory(logics.inventoryManager.currentWarehouse._id)
#      if Session.get("currentInventory")?.creator == Meteor.userId()
#        unless Role.hasPermission(Session.get('currentProfile')._id, Sky.system.merchantPermissions.inventoryEdit.key)
#          console.log 'Bạn không có quyền xác nhận phiếu kiểm kho.'
#        else
#          (Inventory.findOne(Session.get('inventoryWarehouse').inventory)).inventorySuccess()
#          Session.set('allowCreateNewInventory', false)






