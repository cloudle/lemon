Meteor.publish 'providers', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
#  Schema.providers.find({parentMerchant: myProfile.parentMerchant})
  Schema.providers.find({merchant: myProfile.currentMerchant})

Schema.providers.allow
  insert: -> true
  update: -> true
  remove: -> true