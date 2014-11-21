Meteor.publish 'availableBranch', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.merchants.find({
    $or:[
      {_id   : myProfile.parentMerchant}
      {parent: myProfile.parentMerchant}]
  })

Meteor.publish 'myMerchantAndWarehouse', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  myMerchant  = Schema.merchants.find({_id: myProfile.currentMerchant})
  myWarehouse = Schema.warehouses.find({_id: myProfile.currentWarehouse})
  [myMerchant, myWarehouse]


Meteor.publish 'myMerchantProfiles', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile

  parentMerchant = Schema.merchantProfiles.findOne({merchant: myProfile.parentMerchant})
  if !parentMerchant?.latestCheckExpire || parentMerchant?.latestCheckExpire.toDateString() != (new Date()).toDateString()
    Apps.Merchant.checkProductExpireDate(myProfile, parentMerchant.notifyProductExpireRange ? 90)

  if !parentMerchant?.latestCheckReceivable || parentMerchant?.latestCheckReceivable.toDateString() != (new Date()).toDateString()
    Apps.Merchant.checkReceivableExpireDate(myProfile, parentMerchant.notifyReceivableExpireRange ? 90)

  if !parentMerchant?.latestCheckPayable || parentMerchant?.latestCheckPayable.toDateString() != (new Date()).toDateString()
    Apps.Merchant.checkPayableExpireDate(myProfile, parentMerchant.notifyPayableExpireRange ? 90)

  myMerchantProfileQuery = {merchant: myProfile.currentMerchant}
  parentMerchantProfileQuery = {merchant: myProfile.parentMerchant}

  Schema.merchantProfiles.find
    merchant: { $in: [myProfile.currentMerchant, myProfile.parentMerchant] }

Schema.merchantProfiles.allow
  insert: -> true
  update: -> true
  remove: -> true

Schema.merchants.allow
  insert: -> true
  update: -> true
  remove: -> true