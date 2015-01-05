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

userHasPermission = (profile, permission)-> Role.hasPermission(profile._id, permission.key)
userNameBy  = (userId)-> (Schema.userProfiles.findOne({user: userId})).fullName ? Meteor.users.findOne(userId).emails[0].address
Permissions = Apps.Merchant.Permissions
Messages    = Apps.Merchant.NotificationMessages
#------------------------------------------------------------------------------------------------------------------------
sendSellerIfCreatorNotSeller = (profile, sale)->
  creatorName = profile.fullName ? Meteor.user().emails[0].address
  Notification.send(Messages.saleHelper(creatorName, sale.orderCode, sale.finalPrice), sale.seller)

sendAllUserHasPermissionCashierSale = (sale, profile) ->
  allUserHasPermissionCashierSale = Schema.userProfiles.find(
    {
      parentMerchant: profile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Permissions.cashierSale.key)}}
    }).fetch()
  creatorName = profile.fullName ? Meteor.user().emails[0].address
  for receiver in allUserHasPermissionCashierSale
    unless profile.user is receiver.user
     Notification.send(Messages.sendAccountingByNewSale(creatorName, sale.orderCode), receiver.user)
#------------------------------------------------------------------------------------------------------------------------
sendToSellerAndCreatorBySaleConfirm = (cashierName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Messages.sendByCashier(cashierName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Messages.sendCreatorSaleByCashier(cashierName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Messages.sendSellerSaleByCashier(cashierName, creatorName, sale.orderCode), sale.seller)

sendToExporterBySaleConfirm = (creatorName, sale, profile)->
  if sale.paymentsDelivery is 0
    allUserHasPermissionSaleExport = Schema.userProfiles.find(
      {
        parentMerchant: profile.parentMerchant
        roles: {$elemMatch: {$in:Role.rolesOf(Permissions.saleExport.key)}}
      }).fetch()
    for exporter in allUserHasPermissionSaleExport
      unless profile.user is exporter.user
        Notification.send(Messages.sendExporterBySaleExport(creatorName, sale.orderCode), exporter.user)

sendToShipperBySaleConfirm = (creatorName, sale, profile)->
  if sale.paymentsDelivery is 1
    allUserHasPermissionDeliveryConfirm = Schema.userProfiles.find(
      {
        parentMerchant: profile.parentMerchant
        roles: {$elemMatch: {$in:Role.rolesOf(Permissions.deliveryConfirm.key)}}
      }).fetch()
    for shipper in allUserHasPermissionDeliveryConfirm
      unless profile.user is shipper.user
        Notification.send(Messages.sendShipperByNewDelivery(creatorName, sale.orderCode), shipper.user)
#------------------------------------------------------------------------------------------------------------------------
sendToSellerAndCreatorByExporterConfirm = (exporterName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Messages.sendByExporter(exporterName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Messages.sendCreatorSaleByExporter(exporterName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Messages.sendSellerSaleByExporter(exporterName, creatorName, sale.orderCode), sale.seller)

sendToShipperByExporterConfirm = (exporterName, sale, profile)->
  if sale.paymentsDelivery is 1
    shipperId = Schema.deliveries.findOne(sale.delivery).shipper
    unless shipperId is profile.user
      Notification.send(Messages.sendShipperByExport(exporterName, sale.orderCode), shipperId)
#------------------------------------------------------------------------------------------------------------------------
sendToSellerAndCreatorByImporterConfirm = (importerName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Messages.sendByImporter(importerName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Messages.sendCreatorSaleByImporter(importerName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Messages.sendSellerSaleByImporter(importerName, creatorName, sale.orderCode), sale.seller)
#------------------------------------------------------------------------------------------------------------------------
sendToSellerAndCreatorByStatusIsSelected = (shipperName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Messages.sendByShipperSelected(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Messages.sendCreatorSaleByShipperSelected(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Messages.sendSellerSaleByShipperSelected(shipperName, creatorName, sale.orderCode), sale.seller)

sendAllUserHasPermissionExportSale = (creatorName, sale, profile) ->
  allUserHasPermissionExportSale = Schema.userProfiles.find(
    {
      parentMerchant: profile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Permissions.saleExport.key)}}
    }).fetch()
  for exporter in allUserHasPermissionExportSale
    unless profile.user is receiver.user
      Notification.send(Messages.sendExporterBySaleExport(creatorName, sale.orderCode), exporter.user)

sendToSellerAndCreatorByStatusIsWorking = (shipperName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Messages.sendByShipperWorking(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Messages.sendCreatorSaleByShipperWorking(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Messages.sendSellerSaleByShipperWorking(shipperName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsSuccess = (shipperName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Messages.sendByDeliverySuccess(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Messages.sendCreatorSaleByDeliverySuccess(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Messages.sendSellerSaleByDeliverySuccess(shipperName, creatorName, sale.orderCode), sale.seller)

sendToSellerAndCreatorByStatusIsFail = (shipperName, creatorName, sellerName, sale, profile)->
  if sale.seller is sale.creator
    unless sale.creator is profile.user
      Notification.send(Messages.sendByDeliveryFail(shipperName, sale.orderCode), sale.creator)
  else
    unless sale.creator is profile.user
      Notification.send(Messages.sendCreatorSaleByDeliveryFail(shipperName, sellerName, sale.orderCode), sale.creator)
    unless sale.seller is profile.user
      Notification.send(Messages.sendSellerSaleByDeliveryFail(shipperName, creatorName, sale.orderCode), sale.seller)
#------------------------------------------------------------------------------------------------------------------------
sendAllUserHasPermissionReturnConfirm = (creatorName, returns, profile)->
  allUserHasPermissionReturnConfirm = Schema.userProfiles.find(
    {
      parentMerchant: profile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Permissions.returnConfirm.key)}}
    }).fetch()
  for receiver in allUserHasPermissionReturnConfirm
    unless profile.user is receiver.user
      Notification.send(Messages.sendNewReturnCreate(creatorName, returns.returnCode), receiver.user)
#------------------------------------------------------------------------------------------------------------------------
sendAllUserHasPermissionInventoryConfirm = (creatorName, inventoryCode, profile)->
  allUserHasPermissionInventoryConfirm = Schema.userProfiles.find(
    {
      parentMerchant: profile.parentMerchant
      roles: {$elemMatch: {$in:Role.rolesOf(Permissions.inventoryConfirm.key)}}
    }).fetch()
  for receiver in allUserHasPermissionInventoryConfirm
    unless profile.user is receiver.user
      Notification.send(Messages.sendNewInventoryCreate(creatorName, inventoryCode), receiver.user)

Meteor.methods
  permissionChanged: (profile, permission)->
    if permission and userHasPermission(profile, Permissions.permissionManagement)
      allUserOfPermissionChanged = Schema.userProfiles.find(
        {
          parentMerchant: profile.parentMerchant
          roles: {$elemMatch: {$in:[permission._id]}}
        }).fetch()

      creatorName = profile.fullName ? Meteor.user().emails[0].address
      for receiver in allUserOfPermissionChanged
        unless profile.user is receiver.user
          Notification.send(Messages.permissionChanged(creatorName), receiver.user)

  createNewMember: (profile, newMemberName, companyName) ->
    if newMemberName and companyName and userHasPermission(profile, Permissions.permissionManagement)
      for receiver in Schema.userProfiles.find({parentMerchant: profile.parentMerchant}).fetch()
        unless receiver.user is profile.user
          Notification.send(Messages.newMemberJoined(newMemberName, companyName), receiver.user)

  newSaleDefault: (profile, saleId) ->
    sale = Schema.sales.findOne({_id: saleId, creator: profile.user})
    if sale and userHasPermission(profile, Permissions.accountManagement)
      sendSellerIfCreatorNotSeller(profile, sale) if sale.creator isnt sale.seller
      sendAllUserHasPermissionCashierSale(sale, profile)

  saleConfirmByAccounting: (profile, saleId) ->
    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant})
    if sale and userHasPermission(profile, Permissions.cashierSale)
      if sale.received == sale.imported ==  sale.exported == sale.submitted == false and sale.status == true
        cashierName = profile.fullName ? Meteor.user().emails[0].address
        creatorName = userNameBy(sale.creator)
        sellerName  = userNameBy(sale.seller)

        sendToSellerAndCreatorBySaleConfirm(cashierName, creatorName, sellerName, sale, profile)
        sendToExporterBySaleConfirm(creatorName, sale, profile)
        sendToShipperBySaleConfirm(creatorName, sale, profile)

  saleAccountingConfirmByDelivery: (profile, saleId) ->
#    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant})
#    if sale and userHasPermission(Apps.Merchant.Permissions.cashierDelivery, profile)
#      if sale.status == sale.success == sale.received == sale.exported == true and sale.submitted ==  sale.imported == false and sale.paymentsDelivery == 1

  saleConfirmByExporter: (profile, saleId) ->
    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant})
    if sale and userHasPermission(profile, Permissions.saleExport) and saleStatusIsExport(sale)
      exporterName = profile.fullName ? Meteor.user().emails[0].address
      creatorName = userNameBy(sale.creator)
      sellerName = userNameBy(sale.seller)

      sendToSellerAndCreatorByExporterConfirm(exporterName, creatorName, sellerName, sale, profile)
      sendToShipperByExporterConfirm(exporterName, sale, profile)

  saleConfirmImporter: (profile, saleId) ->
    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant})
    if sale and userHasPermission(profile, Permissions.importDelivery) and saleStatusIsExport(sale)
      importerName = profile.fullName ? Meteor.user().emails[0].address
      creatorName = userNameBy(sale.creator)
      sellerName = userNameBy(sale.seller)

      sendToSellerAndCreatorByImporterConfirm(importerName, creatorName, sellerName, sale, profile)

  deliveryNotify: (profile, saleId, status) ->
    sale = Schema.sales.findOne({_id: saleId, merchant: profile.currentMerchant, paymentsDelivery: 1})
    if sale and userHasPermission(profile, Permissions.deliveryConfirm)
      shipperName = profile.fullName ? Meteor.user().emails[0].address
      creatorName = userNameBy(sale.creator)
      sellerName = userNameBy(sale.seller)

      switch status
        when 'selected'
          sendToSellerAndCreatorByStatusIsSelected(shipperName, creatorName, sellerName, sale, profile)
          sendAllUserHasPermissionExportSale(creatorName, sale, profile)
        when 'start'
          sendToSellerAndCreatorByStatusIsWorking(shipperName, creatorName, sellerName, sale, profile)
        when 'success'
          sendToSellerAndCreatorByStatusIsSuccess(shipperName, creatorName, sellerName, sale, profile)
        when 'fail'
          sendToSellerAndCreatorByStatusIsFail(shipperName, creatorName, sellerName, sale, profile)

  returnConfirm: (profile, returnId)->
    returns = Schema.returns.findOne({_id: returnId, merchant: profile.currentMerchant, status: 0})
    if returns and userHasPermission(profile, Permissions.returnCreate)
      creatorName = profile.fullName ? Meteor.user().emails[0].address
      sendAllUserHasPermissionReturnConfirm(creatorName, returns, profile)

  returnSubmit: (profile, returnId)->
    returns = Schema.returns.findOne({_id: returnId, merchant: profile.currentMerchant, status: 1})
    if returns and userHasPermission(profile, Permissions.returnConfirm)
      unless profile.user is returns.creator
        creatorName = profile.fullName ? Meteor.user().emails[0].address
        Notification.send(Messages.sendCreatorByReturnConfirm(creatorName, returns.returnCode), returns.creator)

  inventoryNewCreate: (profile, inventoryId)->
    inventory = Schema.inventories.findOne({_id: inventoryId, merchant: profile.currentMerchant, creator: {$ne: profile.user}})
    if inventory and userHasPermission(profile, Permissions.inventoryEdit)
      creatorName = profile.fullName ? Meteor.user().emails[0].address
      inventoryCode = inventory.inventoryCode ? inventory.description
      sendAllUserHasPermissionInventoryConfirm(creatorName, inventoryCode, profile)
