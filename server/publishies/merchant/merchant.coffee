Meteor.publish 'availableBranch', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.merchants.find({
    $or:[
      {_id   : myProfile.parentMerchant}
      {parent: myProfile.parentMerchant}]
  })

Schema.merchants.allow
  insert: -> true
  update: -> true
  remove: -> true