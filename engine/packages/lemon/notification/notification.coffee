userHasPermission = (permission, profile)-> Role.hasPermission(profile._id, permission.key)

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

allUserHasPermissionOf =(merchantId, permission)->
  Schema.userProfiles.find({
    parentMerchant: merchantId
    roles: {$elemMatch: {$in:Role.rolesOf(permission.key)}}
  }).fetch()

sendAllUserHasPermissionWarehouseManagementByProductExpire = (product, sender)->
  for receiver in allUserHasPermissionOf(sender.parentMerchant, Apps.Merchant.Permissions.warehouseManagement)
    sendNotificationOptional(
      sender.user,
      receiver.user,
      Apps.Merchant.NotificationMessages.productExpireDate(product.name, product.day, product.place),
      product._id,
      Apps.Merchant.notificationGroup.expireDate.key)

sendAllUserHasPermissionWarehouseManagementByReceivableExpire = (transaction, sender)->
  for receiver in allUserHasPermissionOf(sender.parentMerchant, Apps.Merchant.Permissions.warehouseManagement)
    sendNotificationOptional(
      sender.user,
      receiver.user,
      Apps.Merchant.NotificationMessages.receivableExpireDate(transaction.customerName, transaction.day),
      transaction._id,
      Apps.Merchant.notificationGroup.receivableDate.key)

sendAllUserHasPermissionWarehouseManagementByPayableExpire = (transaction, sender)->
  for receiver in allUserHasPermissionOf(sender.parentMerchant, Apps.Merchant.Permissions.warehouseManagement)
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

#---------------------------------------------------------------------------------------------------------------------------------------
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