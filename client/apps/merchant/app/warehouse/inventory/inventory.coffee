

#formatViewInventorySearch = (item) -> "#{item.display}" if item
#
#checkAllowCreate = (context) ->
#  description = context.ui.$description.val()
#
#  if description.length > 1
#    Session.set('allowCreateNewInventory', true)
#  else
#    Session.set('allowCreateNewInventory', false)




lemon.defineApp Template.inventory,
#  inventory: -> Session.get('currentInventory')
#  show: -> Session.get('showCreateNewInventory')
#  allowCreate: -> if Session.get('allowCreateNewInventory') then 'btn-success' else 'btn-default disabled'
#  showCreate: -> return "display: none" if Session.get('currentInventory') || Session.get('inventoryWarehouse')?.checkingInventory == true
#  showDestroy: -> return "display: none" if !Session.get('currentInventory') || Session.get('currentInventory')?.submit == true
#  showDescription: ->
#    if Session.get('inventoryWarehouse')?.checkingInventory == true and !Session.get("currentInventory") and Session.get("historyInventories")
#      return "display: none"
#  showSubmit: ->
#    return "display: none" if !Session.get('availableProductDetails')
#    for detail in Session.get('availableProductDetails')
#      if detail.lock == false || detail.submit == false || detail.success == true
#        return "display: none"

  created: ->
    Session.setDefault('showCreateNewInventory', true)
    Session.setDefault('allowCreateNewInventory', false)


  events:
    'click .createInventory': (event, template)->
      if template.ui.$description.val().length > 1
        unless Role.hasPermission(Session.get('currentProfile')._id, Sky.system.merchantPermissions.inventoryCreate.key)
          console.log 'Bạn không có quyền tạo phiếu kiểm kho.'
        else
          Inventory.createByWarehouse(Session.get('inventoryWarehouse')._id, template.ui.$description.val())
          Session.set('allowCreateNewInventory', false)

    'click .destroyInventory': (event, template)->
      if Session.get("currentInventory")?.creator == Meteor.userId()
        unless Role.hasPermission(Session.get('currentProfile')._id, Sky.system.merchantPermissions.inventoryDestroy.key)
          console.log 'Bạn không có quyền hủy phiếu kiểm kho.'
        else
          (Inventory.findOne(Session.get('inventoryWarehouse').inventory)).inventoryDestroy()
          Session.set('allowCreateNewInventory', false)

    'click .submitInventory': (event, template)->
      if Session.get("currentInventory")?.creator == Meteor.userId()
        unless Role.hasPermission(Session.get('currentProfile')._id, Sky.system.merchantPermissions.inventoryEdit.key)
          console.log 'Bạn không có quyền xác nhận phiếu kiểm kho.'
        else
          (Inventory.findOne(Session.get('inventoryWarehouse').inventory)).inventorySuccess()
          Session.set('allowCreateNewInventory', false)

    "input input": (event, template) -> checkAllowCreate(template)

    'blur input': (event, template)->
      if Session.get("currentInventory")
        if template.ui.$description.val().length > 1
          Schema.inventories.update Session.get("currentInventory")._id, $set:{description: template.ui.$description.val()}
        else
          template.ui.$description.val(Session.get("currentInventory").description)



