Meteor.publish 'providers', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.providers.find({parentMerchant: myProfile.parentMerchant}, {fields: {name: 1}})

Schema.providers.allow
  insert: -> true
  update: -> true
  remove: -> true