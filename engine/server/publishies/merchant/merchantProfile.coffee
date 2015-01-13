Meteor.publish 'myMerchantProfile', ->
  return [] if !@userId
  profile = Schema.userProfiles.findOne({user: @userId})
  return [] if !profile
  Schema.merchantProfiles.find({merchant: profile.currentMerchant})

Schema.merchantProfiles.allow
  insert: -> true
  update: -> true
  remove: -> true