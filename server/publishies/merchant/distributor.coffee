Meteor.publish 'distributors', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
#  Schema.providers.find({parentMerchant: myProfile.parentMerchant})
  Schema.distributors.find({merchant: myProfile.currentMerchant})

Schema.distributors.allow
  insert: -> true
  update: -> true
  remove: -> true