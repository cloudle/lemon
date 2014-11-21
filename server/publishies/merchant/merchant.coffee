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