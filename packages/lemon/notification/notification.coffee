saleStatusIsExport = (sale)->
  if sale.status == sale.received == true and sale.submitted == sale.exported == sale.imported == false and (sale.paymentsDelivery == 0 || sale.paymentsDelivery == 1)
    true
  else
    false

saleStatusIsImport = (sale)->
  if sale.status == sale.received == sale.exported == true and sale.submitted == sale.imported == false and sale.paymentsDelivery == 1
    true
  else
    false


userHasPermission = (permission, userProfile)-> Role.hasPermission(userProfile._id, permission.key)
userNameBy = (userId)-> (Schema.userProfiles.findOne({user: userId})).fullName ? Meteor.users.findOne(userId).emails[0].address

allUserHasPermissionOf =(merchantId, permission)->
  Schema.userProfiles.find({
    parentMerchant: merchantId
    roles: {$elemMatch: {$in:Role.rolesOf(permission.key)}}
  }).fetch()

sendAllUserOf = (permission, userProfile)->
  if permission and userHasPermission(Apps.Merchant.Permissions.permissionManagement, userProfile)
    allUserOfPermissionChanged = Schema.userProfiles.find(
      {
        parentMerchant: userProfile.parentMerchant
        roles: {$elemMatch: {$in:[permission.name]}}
      }).fetch()

    creatorName = userProfile.fullName ? Meteor.user().emails[0].address
    for receiver in allUserOfPermissionChanged
      unless userProfile.user is receiver.user
        Notification.send(Apps.Merchant.NotificationMessages.permissionChanged(creatorName), receiver.user)

sendAllUserOnMerchantByNewMember = (newMemberName, companyName, userProfile)->
  if newMemberName and companyName and userHasPermission(Apps.Merchant.Permissions.permissionManagement, userProfile)
    for receiver in Schema.userProfiles.find({parentMerchant: userProfile.parentMerchant}).fetch()
      unless receiver.user is userProfile.user
        Notification.send(Apps.Merchant.NotificationMessages.newMemberJoined(newMemberName, companyName), receiver.user)

sendSellerIfCreatorNotSeller = (sale, userProfile)->
  creatorName = userProfile.fullName ? Meteor.user().emails[0].address
  Notification.send(Apps.Merchant.NotificationMessages.saleHelper(creatorName, sale.orderCode, sale.finalPrice), sale.seller)

sendAllUserHasPermissionCashierSale = (sale, userProfile) ->
  allUserHasPermissionCashierSale = Schema.userProfiles.find(
    {
      parentMerchant: userProfile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.cashierSale.key)}}
    }).fetch()
  creatorName = userProfile.fullName ? Meteor.user().emails[0].address
  for receiver in allUserHasPermissionCashierSale
    unless userProfile.user is receiver.user
      Notification.send(Apps.Merchant.NotificationMessages.sendAccountingByNewSale(creatorName, sale.orderCode), receiver.user)

sendToSellerAndCreatorBySaleConfirm = (cashierName, creatorName, sellerName, sale, userProfile)->
  if sale.seller is sale.creator
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByCashier(cashierName, sale.orderCode), sale.creator)
  else
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByCashier(cashierName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByCashier(cashierName, creatorName, sale.orderCode), sale.seller)

sendToExporterBySaleConfirm = (creatorName, sale, userProfile)->
  if sale.paymentsDelivery is 0
    allUserHasPermissionSaleExport = Schema.userProfiles.find(
      {
        parentMerchant: userProfile.parentMerchant
        roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.saleExport.key)}}
      }).fetch()
    for exporter in allUserHasPermissionSaleExport
      unless userProfile.user is exporter.user
        Notification.send(Apps.Merchant.NotificationMessages.sendExporterBySaleExport(creatorName, sale.orderCode), exporter.user)

sendToShipperBySaleConfirm = (creatorName, sale, userProfile)->
  if sale.paymentsDelivery is 1
    allUserHasPermissionDeliveryConfirm = Schema.userProfiles.find(
      {
        parentMerchant: userProfile.parentMerchant
        roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.deliveryConfirm.key)}}
      }).fetch()
    for shipper in allUserHasPermissionDeliveryConfirm
      unless userProfile.user is shipper.user
        Notification.send(Apps.Merchant.NotificationMessages.sendShipperByNewDelivery(creatorName, sale.orderCode), shipper.user)

sendToSellerAndCreatorByExporterConfirm = (exporterName, creatorName, sellerName, sale, userProfile)->
  if sale.seller is sale.creator
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByExporter(exporterName, sale.orderCode), sale.creator)
  else
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByExporter(exporterName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByExporter(exporterName, creatorName, sale.orderCode), sale.seller)

sendToShipperByExporterConfirm = (exporterName, sale, userProfile)->
  if sale.paymentsDelivery is 1
    shipperId = Schema.deliveries.findOne(sale.delivery).shipper
    unless shipperId is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendShipperByExport(exporterName, sale.orderCode), shipperId)

sendToSellerAndCreatorByImporterConfirm = (importerName, creatorName, sellerName, sale, userProfile)->
  if sale.seller is sale.creator
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByImporter(importerName, sale.orderCode), sale.creator)
  else
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByImporter(importerName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByImporter(importerName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsSelected = (shipperName, creatorName, sellerName, sale, userProfile)->
  if sale.seller is sale.creator
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByShipperSelected(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByShipperSelected(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByShipperSelected(shipperName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsWorking = (shipperName, creatorName, sellerName, sale, userProfile)->
  if sale.seller is sale.creator
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByShipperWorking(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByShipperWorking(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByShipperWorking(shipperName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsSuccess = (shipperName, creatorName, sellerName, sale, userProfile)->
  if sale.seller is sale.creator
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByDeliverySuccess(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByDeliverySuccess(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByDeliverySuccess(shipperName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsFail = (shipperName, creatorName, sellerName, sale, userProfile)->
  if sale.seller is sale.creator
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByDeliveryFail(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByDeliveryFail(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is userProfile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByDeliveryFail(shipperName, creatorName, sale.orderCode), sale.seller)

sendAllUserHasPermissionExportSale = (creatorName, sale, userProfile) ->
  allUserHasPermissionExportSale = Schema.userProfiles.find(
    {
      parentMerchant: userProfile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.saleExport.key)}}
    }).fetch()
  for exporter in allUserHasPermissionExportSale
    unless userProfile.user is receiver.user
      Notification.send(Apps.Merchant.NotificationMessages.sendExporterBySaleExport(creatorName, sale.orderCode), exporter.user)

sendAllUserHasPermissionReturnConfirm = (creatorName, returns, userProfile)->
  allUserHasPermissionReturnConfirm = Schema.userProfiles.find(
    {
      parentMerchant: userProfile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.returnConfirm.key)}}
    }).fetch()
  for receiver in allUserHasPermissionReturnConfirm
    unless userProfile.user is receiver.user
      Notification.send(Apps.Merchant.NotificationMessages.sendNewReturnCreate(creatorName, returns.returnCode), receiver.user)

sendAllUserHasPermissionInventoryConfirm = (creatorName, inventoryCode, userProfile)->
  allUserHasPermissionInventoryConfirm = Schema.userProfiles.find(
    {
      parentMerchant: userProfile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.inventoryConfirm.key)}}
    }).fetch()
  for receiver in allUserHasPermissionInventoryConfirm
    unless userProfile.user is receiver.user
      Notification.send(Apps.Merchant.NotificationMessages.sendNewInventoryCreate(creatorName, inventoryCode), receiver.user)


sendAllUserHasPermissionWarehouseManagementByExpire = (product, userProfile)->
  for warehouseManagement in allUserHasPermissionOf(userProfile.parentMerchant, Apps.Merchant.Permissions.warehouseManagement)
    unless userProfile.user is warehouseManagement.user
      Meteor.call("sendNotificationOptional",
        Apps.Merchant.NotificationMessages.productExpireDate(product.name, product.day, product.place),
        warehouseManagement.user,
        product._id,
        Apps.Merchant.notificationGroup.expireDate.key)

sendAllUserHasPermissionWarehouseManagementAlertQuality = (product, userProfile)->
  for warehouseManagement in allUserHasPermissionOf(userProfile.parentMerchant, Apps.Merchant.Permissions.warehouseManagement)
    unless userProfile.user is warehouseManagement.user
      Meteor.call("sendNotificationOptional",
        Apps.Merchant.NotificationMessages.productAlertQuality(product.name, product.quality, product.place),
        warehouseManagement.user,
        product._id,
        Apps.Merchant.notificationGroup.alertQuality.key)



Schema.add 'notifications', "Notification", class Notification
  dump: ""
  @send: (message, receiver, notificationType = Apps.Merchant.notificationTypes.notify.key) ->
    newNotification = {
      sender: Meteor.userId()
      receiver: receiver
      message: message
      notificationType: notificationType
    }
    Schema.notifications.insert newNotification

  @productExpire: (product)->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserHasPermissionWarehouseManagementByExpire(product, userProfile)

  @productAlertQuality: (product)->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserHasPermissionWarehouseManagementAlertQuality(product, userProfile)

  @permissionChanged: (permission) ->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserOf(permission, userProfile)

  @createNewMember: (newMemberName, companyName) ->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserOnMerchantByNewMember(newMemberName, companyName, userProfile)

  @newSaleDefault: (saleId) ->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, creator: userProfile.user})
    if sale and userHasPermission(Apps.Merchant.Permissions.permissionManagement, userProfile)
      sendSellerIfCreatorNotSeller(sale, userProfile) if sale.creator isnt sale.seller
      sendAllUserHasPermissionCashierSale(sale, userProfile)


  @saleConfirmByAccounting: (saleId) ->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: userProfile.currentMerchant})
    if sale and userHasPermission(Apps.Merchant.Permissions.cashierSale, userProfile)
      if sale.received == sale.imported ==  sale.exported == sale.submitted == false and sale.status == true
        cashierName = userProfile.fullName ? Meteor.user().emails[0].address
        creatorName = userNameBy(sale.creator)
        sellerName  = userNameBy(sale.seller)

        sendToSellerAndCreatorBySaleConfirm(cashierName, creatorName, sellerName, sale, userProfile)
        sendToExporterBySaleConfirm(creatorName, sale, userProfile)
        sendToShipperBySaleConfirm(creatorName, sale, userProfile)

  @saleAccountingConfirmByDelivery: (saleId) ->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: userProfile.currentMerchant})
#    if sale and userHasPermission(Apps.Merchant.Permissions.cashierDelivery, userProfile)
#      if sale.status == sale.success == sale.received == sale.exported == true and sale.submitted ==  sale.imported == false and sale.paymentsDelivery == 1

#kho
  @saleConfirmByExporter: (saleId) ->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: userProfile.currentMerchant})

    if sale and userHasPermission(Apps.Merchant.Permissions.saleExport, userProfile) and saleStatusIsExport(sale)
      exporterName = userProfile.fullName ? Meteor.user().emails[0].address
      creatorName = userNameBy(sale.creator)
      sellerName = userNameBy(sale.seller)

      sendToSellerAndCreatorByExporterConfirm(exporterName, creatorName, sellerName, sale, userProfile)
      sendToShipperByExporterConfirm(exporterName, sale, userProfile)

  @saleConfirmImporter: (saleId) ->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: userProfile.currentMerchant})

    if sale and userHasPermission(Apps.Merchant.Permissions.importDelivery, userProfile) and saleStatusIsExport(sale)
      importerName = userProfile.fullName ? Meteor.user().emails[0].address
      creatorName = userNameBy(sale.creator)
      sellerName = userNameBy(sale.seller)

      sendToSellerAndCreatorByImporterConfirm(importerName, creatorName, sellerName, sale, userProfile)

  @deliveryNotify: (saleId, status) ->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: userProfile.currentMerchant, paymentsDelivery: 1})

    if sale and userHasPermission(Apps.Merchant.Permissions.deliveryConfirm, userProfile)
      shipperName = userProfile.fullName ? Meteor.user().emails[0].address
      creatorName = userNameBy(sale.creator)
      sellerName = userNameBy(sale.seller)

      switch status
        when 'selected'
          sendToSellerAndCreatorByStatusIsSelected(shipperName, creatorName, sellerName, sale, userProfile)
          sendAllUserHasPermissionExportSale(creatorName, sale, userProfile)
        when 'working'
          sendToSellerAndCreatorByStatusIsWorking(shipperName, creatorName, sellerName, sale, userProfile)
        when 'success'
          sendToSellerAndCreatorByStatusIsSuccess(shipperName, creatorName, sellerName, sale, userProfile)
        when 'fail'
          sendToSellerAndCreatorByStatusIsFail(shipperName, creatorName, sellerName, sale, userProfile)

  @returnConfirm: (returnId)->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    returns = Schema.returns.findOne({_id: returnId, merchant: userProfile.currentMerchant, status: 0})

    if returns and userHasPermission(Apps.Merchant.Permissions.returnCreate, userProfile)
      creatorName = userProfile.fullName ? Meteor.user().emails[0].address
      sendAllUserHasPermissionReturnConfirm(creatorName, returns, userProfile)


  @returnSubmit: (returnId)->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    returns = Schema.returns.findOne({_id: returnId, merchant: userProfile.currentMerchant, status: 1})

    if returns and userHasPermission(Apps.Merchant.Permissions.returnConfirm, userProfile)
      unless userProfile.user is returns.creator
        creatorName = userProfile.fullName ? Meteor.user().emails[0].address
        @send(Apps.Merchant.NotificationMessages.sendCreatorByReturnConfirm(creatorName, returns.returnCode), returns.creator)

#kiem kho
  @inventoryNewCreate: (inventoryId)->
    userProfile = Schema.userProfiles.findOne({user: Meteor.userId()})
    inventory = Schema.inventories.findOne({_id: inventoryId, merchant: userProfile.currentMerchant, creator: {$ne: userProfile.user}})

    if inventory and userHasPermission(Apps.Merchant.Permissions.inventoryEdit, userProfile)
      creatorName = userProfile.fullName ? Meteor.user().emails[0].address
      inventoryCode = inventory.inventoryCode ? inventory.description
      sendAllUserHasPermissionInventoryConfirm(creatorName, inventoryCode, userProfile)