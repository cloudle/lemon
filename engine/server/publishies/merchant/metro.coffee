Meteor.publish 'myMetroSummaries', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.metroSummaries.find({parentMerchant: myProfile.parentMerchant, merchant: myProfile.currentMerchant})

Schema.metroSummaries.allow
  insert: -> true
  update: -> true
  remove: -> true