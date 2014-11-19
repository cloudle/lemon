Meteor.publish 'distributors', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.distributors.find({parentMerchant: myProfile.parentMerchant})

Schema.distributors.allow
  insert: -> true
  update: -> true
  remove: -> true