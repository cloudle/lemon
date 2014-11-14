Meteor.publish 'providers', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.providers.find({parentMerchant: myProfile.parentMerchant})

Schema.providers.allow
  insert: (userId, provider) ->
    if Schema.providers.findOne({
      parentMerchant: provider.parentMerchant
      name: provider.name
    }) then false else true
  update: (userId, provider) -> true
  remove: (userId, provider) -> true