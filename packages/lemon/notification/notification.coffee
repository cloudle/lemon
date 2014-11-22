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

sendNotificationOptional = (sender, receiver, message, product, notificationGroup, notificationType = Apps.Merchant.notificationTypes.notify.key) ->
  newNotification = {
    sender  : sender
    receiver: receiver
    message : message
    product : product
    group   : notificationGroup
    notificationType: notificationType
  }
  findOldNotification = Schema.notifications.findOne({
    sender  : newNotification.sender
    receiver: newNotification.receiver
    product : newNotification.product
    group   : newNotification.group
    notificationType  : newNotification.notificationType
  })

  if findOldNotification
    Schema.notifications.update findOldNotification._id, $set:{message: newNotification.message}
  else
    Schema.notifications.insert newNotification

allUserProfile = (merchantId)-> Schema.userProfiles.find({parentMerchant: merchantId}).fetch()


userHasPermission = (permission, profile)-> Role.hasPermission(profile._id, permission.key)
userNameBy = (userId)-> (Schema.userProfiles.findOne({user: userId})).fullName ? Meteor.users.findOne(userId).emails[0].address

allUserHasPermissionOf =(merchantId, permission)->
  Schema.userProfiles.find({
    parentMerchant: merchantId
    roles: {$elemMatch: {$in:Role.rolesOf(permission.key)}}
  }).fetch()

sendAllUserOf = (permission, profile)->
  if permission and userHasPermission(Apps.Merchant.Permissions.permissionManagement, profile)
    allUserOfPermissionChanged = Schema.userProfiles.find(
      {
        parentMerchant: profile.parentMerchant
        roles: {$elemMatch: {$in:[permission.name]}}
      }).fetch()

    creatorName = profile.fullName ? Meteor.user().emails[0].address
    for receiver in allUserOfPermissionChanged
      unless profile.user is receiver.user
        Notification.send(Apps.Merchant.NotificationMessages.permissionChanged(creatorName), receiver.user)

sendAllUserOnMerchantByNewMember = (newMemberName, companyName, profile)->
  if newMemberName and companyName and userHasPermission(Apps.Merchant.Permissions.permissionManagement, profile)
    for receiver in Schema.userProfiles.find({parentMerchant: profile.parentMerchant}).fetch()
      unless receiver.user is profile.user
        Notification.send(Apps.Merchant.NotificationMessages.newMemberJoined(newMemberName, companyName), receiver.user)

sendSellerIfCreatorNotSeller = (sale, profile)->
  creatorName = profile.fullName ? Meteor.user().emails[0].address
  Notification.send(Apps.Merchant.NotificationMessages.saleHelper(creatorName, sale.orderCode, sale.finalPrice), sale.seller)

sendAllUserHasPermissionCashierSale = (sale, profile) ->
  allUserHasPermissionCashierSale = Schema.userProfiles.find(
    {
      parentMerchant: profile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.cashierSale.key)}}
    }).fetch()
  creatorName = profile.fullName ? Meteor.user().emails[0].address
  for receiver in allUserHasPermissionCashierSale
    unless profile.user is receiver.user
      Notification.send(Apps.Merchant.NotificationMessages.sendAccountingByNewSale(creatorName, sale.orderCode), receiver.user)

sendToSellerAndCreatorBySaleConfirm = (cashierName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByCashier(cashierName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByCashier(cashierName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByCashier(cashierName, creatorName, sale.orderCode), sale.seller)

sendToExporterBySaleConfirm = (creatorName, sale, profile)->
  if sale.paymentsDelivery is 0
    allUserHasPermissionSaleExport = Schema.userProfiles.find(
      {
        parentMerchant: profile.parentMerchant
        roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.saleExport.key)}}
      }).fetch()
    for exporter in allUserHasPermissionSaleExport
      unless profile.user is exporter.user
        Notification.send(Apps.Merchant.NotificationMessages.sendExporterBySaleExport(creatorName, sale.orderCode), exporter.user)

sendToShipperBySaleConfirm = (creatorName, sale, profile)->
  if sale.paymentsDelivery is 1
    allUserHasPermissionDeliveryConfirm = Schema.userProfiles.find(
      {
        parentMerchant: profile.parentMerchant
        roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.deliveryConfirm.key)}}
      }).fetch()
    for shipper in allUserHasPermissionDeliveryConfirm
      unless profile.user is shipper.user
        Notification.send(Apps.Merchant.NotificationMessages.sendShipperByNewDelivery(creatorName, sale.orderCode), shipper.user)

sendToSellerAndCreatorByExporterConfirm = (exporterName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByExporter(exporterName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByExporter(exporterName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByExporter(exporterName, creatorName, sale.orderCode), sale.seller)

sendToShipperByExporterConfirm = (exporterName, sale, profile)->
  if sale.paymentsDelivery is 1
    shipperId = Schema.deliveries.findOne(sale.delivery).shipper
    unless shipperId is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendShipperByExport(exporterName, sale.orderCode), shipperId)

sendToSellerAndCreatorByImporterConfirm = (importerName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByImporter(importerName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByImporter(importerName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByImporter(importerName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsSelected = (shipperName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByShipperSelected(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByShipperSelected(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByShipperSelected(shipperName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsWorking = (shipperName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByShipperWorking(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByShipperWorking(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByShipperWorking(shipperName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsSuccess = (shipperName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByDeliverySuccess(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByDeliverySuccess(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByDeliverySuccess(shipperName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsFail = (shipperName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendByDeliveryFail(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendCreatorSaleByDeliveryFail(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Apps.Merchant.NotificationMessages.sendSellerSaleByDeliveryFail(shipperName, creatorName, sale.orderCode), sale.seller)

sendAllUserHasPermissionExportSale = (creatorName, sale, profile) ->
  allUserHasPermissionExportSale = Schema.userProfiles.find(
    {
      parentMerchant: profile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.saleExport.key)}}
    }).fetch()
  for exporter in allUserHasPermissionExportSale
    unless profile.user is receiver.user
      Notification.send(Apps.Merchant.NotificationMessages.sendExporterBySaleExport(creatorName, sale.orderCode), exporter.user)

sendAllUserHasPermissionReturnConfirm = (creatorName, returns, profile)->
  allUserHasPermissionReturnConfirm = Schema.userProfiles.find(
    {
      parentMerchant: profile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.returnConfirm.key)}}
    }).fetch()
  for receiver in allUserHasPermissionReturnConfirm
    unless profile.user is receiver.user
      Notification.send(Apps.Merchant.NotificationMessages.sendNewReturnCreate(creatorName, returns.returnCode), receiver.user)

sendAllUserHasPermissionInventoryConfirm = (creatorName, inventoryCode, profile)->
  allUserHasPermissionInventoryConfirm = Schema.userProfiles.find(
    {
      parentMerchant: profile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Apps.Merchant.Permissions.inventoryConfirm.key)}}
    }).fetch()
  for receiver in allUserHasPermissionInventoryConfirm
    unless profile.user is receiver.user
      Notification.send(Apps.Merchant.NotificationMessages.sendNewInventoryCreate(creatorName, inventoryCode), receiver.user)


sendAllUserHasPermissionWarehouseManagementByProductExpire = (product, sender)->
  for receiver in allUserHasPermissionOf(sender.parentMerchant, Apps.Merchant.Permissions.warehouseManagement)
    sendNotificationOptional(
      sender.user,
      receiver.user,
      Apps.Merchant.NotificationMessages.productExpireDate(product.name, product.day, product.place),
      product._id,
      Apps.Merchant.notificationGroup.expireDate.key) if sender.user isnt receiver.user


sendAllUserHasPermissionWarehouseManagementByReceivableExpire = (transaction, sender)->
  for receiver in allUserProfile(sender.parentMerchant)
    sendNotificationOptional(
      sender.user,
      receiver.user,
      Apps.Merchant.NotificationMessages.receivableExpireDate(transaction.customerName, transaction.day),
      transaction._id,
      Apps.Merchant.notificationGroup.receivableDate.key)

sendAllUserHasPermissionWarehouseManagementByPayableExpire = (transaction, sender)->
  for receiver in allUserProfile(sender.parentMerchant)
    sendNotificationOptional(
      sender.user,
      receiver.user,
      Apps.Merchant.NotificationMessages.payableExpireDate(transaction.companyName, transaction.day),
      transaction._id,
      Apps.Merchant.notificationGroup.payableDate.key)
    

sendAllUserHasPermissionWarehouseManagementAlertQuality = (product, sender)->
  for warehouseManagement in allUserHasPermissionOf(profile.parentMerchant, Apps.Merchant.Permissions.warehouseManagement)
    unless sender.user is warehouseManagement.user
      sendNotificationOptional(
        sender.user,
        warehouseManagement.user,
        Apps.Merchant.NotificationMessages.productAlertQuality(product.name, product.quality, product.place),
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

  @productExpire: (product, profile)->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserHasPermissionWarehouseManagementByProductExpire(product, profile)

  @receivableExpire: (transaction, profile)->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserHasPermissionWarehouseManagementByReceivableExpire(transaction, profile)

  @payableExpire: (transaction, profile)->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserHasPermissionWarehouseManagementByPayableExpire(transaction, profile)

  @productAlertQuality: (product, profile)->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserHasPermissionWarehouseManagementAlertQuality(product, profile)

  @permissionChanged: (permission, profile) ->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserOf(permission, profile)

  @createNewMember: (newMemberName, companyName, profile) ->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sendAllUserOnMerchantByNewMember(newMemberName, companyName, profile)

  @newSaleDefault: (saleId, profile) ->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, creator: profile.user})
    if sale and userHasPermission(Apps.Merchant.Permissions.permissionManagement, profile)
      sendSellerIfCreatorNotSeller(sale, profile) if sale.creator isnt sale.seller
      sendAllUserHasPermissionCashierSale(sale, profile)


  @saleConfirmByAccounting: (saleId, profile) ->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant})
    if sale and userHasPermission(Apps.Merchant.Permissions.cashierSale, profile)
      if sale.received == sale.imported ==  sale.exported == sale.submitted == false and sale.status == true
        cashierName = profile.fullName ? Meteor.user().emails[0].address
        creatorName = userNameBy(sale.creator)
        sellerName  = userNameBy(sale.seller)

        sendToSellerAndCreatorBySaleConfirm(cashierName, creatorName, sellerName, sale, profile)
        sendToExporterBySaleConfirm(creatorName, sale, profile)
        sendToShipperBySaleConfirm(creatorName, sale, profile)

  @saleAccountingConfirmByDelivery: (saleId, profile) ->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant})
#    if sale and userHasPermission(Apps.Merchant.Permissions.cashierDelivery, profile)
#      if sale.status == sale.success == sale.received == sale.exported == true and sale.submitted ==  sale.imported == false and sale.paymentsDelivery == 1

#kho
  @saleConfirmByExporter: (saleId, profile) ->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant})

    if sale and userHasPermission(Apps.Merchant.Permissions.saleExport, profile) and saleStatusIsExport(sale)
      exporterName = profile.fullName ? Meteor.user().emails[0].address
      creatorName = userNameBy(sale.creator)
      sellerName = userNameBy(sale.seller)

      sendToSellerAndCreatorByExporterConfirm(exporterName, creatorName, sellerName, sale, profile)
      sendToShipperByExporterConfirm(exporterName, sale, profile)

  @saleConfirmImporter: (saleId, profile) ->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant})

    if sale and userHasPermission(Apps.Merchant.Permissions.importDelivery, profile) and saleStatusIsExport(sale)
      importerName = profile.fullName ? Meteor.user().emails[0].address
      creatorName = userNameBy(sale.creator)
      sellerName = userNameBy(sale.seller)

      sendToSellerAndCreatorByImporterConfirm(importerName, creatorName, sellerName, sale, profile)

  @deliveryNotify: (saleId, status, profile) ->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant, paymentsDelivery: 1})

    if sale and userHasPermission(Apps.Merchant.Permissions.deliveryConfirm, profile)
      shipperName = profile.fullName ? Meteor.user().emails[0].address
      creatorName = userNameBy(sale.creator)
      sellerName = userNameBy(sale.seller)

      switch status
        when 'selected'
          sendToSellerAndCreatorByStatusIsSelected(shipperName, creatorName, sellerName, sale, profile)
          sendAllUserHasPermissionExportSale(creatorName, sale, profile)
        when 'working'
          sendToSellerAndCreatorByStatusIsWorking(shipperName, creatorName, sellerName, sale, profile)
        when 'success'
          sendToSellerAndCreatorByStatusIsSuccess(shipperName, creatorName, sellerName, sale, profile)
        when 'fail'
          sendToSellerAndCreatorByStatusIsFail(shipperName, creatorName, sellerName, sale, profile)

  @returnConfirm: (returnId, profile)->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    returns = Schema.returns.findOne({_id: returnId, merchant: profile.currentMerchant, status: 0})

    if returns and userHasPermission(Apps.Merchant.Permissions.returnCreate, profile)
      creatorName = profile.fullName ? Meteor.user().emails[0].address
      sendAllUserHasPermissionReturnConfirm(creatorName, returns, profile)


  @returnSubmit: (returnId, profile)->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    returns = Schema.returns.findOne({_id: returnId, merchant: profile.currentMerchant, status: 1})

    if returns and userHasPermission(Apps.Merchant.Permissions.returnConfirm, profile)
      unless profile.user is returns.creator
        creatorName = profile.fullName ? Meteor.user().emails[0].address
        @send(Apps.Merchant.NotificationMessages.sendCreatorByReturnConfirm(creatorName, returns.returnCode), returns.creator)

#kiem kho
  @inventoryNewCreate: (inventoryId, profile)->
    if !profile then profile = Schema.userProfiles.findOne({user: Meteor.userId()})
    inventory = Schema.inventories.findOne({_id: inventoryId, merchant: profile.currentMerchant, creator: {$ne: profile.user}})

    if inventory and userHasPermission(Apps.Merchant.Permissions.inventoryEdit, profile)
      creatorName = profile.fullName ? Meteor.user().emails[0].address
      inventoryCode = inventory.inventoryCode ? inventory.description
      sendAllUserHasPermissionInventoryConfirm(creatorName, inventoryCode, profile)