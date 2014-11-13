#xóa phiếu kiểm kho đang kiểm kho danh dỡ của kho
logics.inventoryManager.destroyInventory = (warehouseId)->
  userSession = Schema.userSessions.findOne({user: Meteor.userId()})
  if !userSession then return console.log 'Bạn chưa đăng nhập'

#     'Bạn không có quyền hủy phiếu kiểm kho.' unless Role.hasPermission(userProfile._id, Sky.system.merchantPermissions.inventoryDestroy.key)
  warehouse = Schema.warehouses.findOne({_id: warehouseId, merchant: userSession.currentInventoryBranchSelection})
  if !warehouse then return console.log 'Kho hang khong ton tai'
  if warehouse.checkingInventory is false then console.log 'Kho hang khong co dang kiem kho'

  for detail in Schema.inventoryDetails.find({inventory: warehouse.inventory}).fetch()
    Schema.inventoryDetails.remove detail._id
  Schema.inventories.remove warehouse.inventory
  Schema.warehouses.update warehouse._id, $set:{checkingInventory: false}, $unset:{inventory: ""}
  console.log 'Hủy Phiếu Kiểm Kho Thành Công'

