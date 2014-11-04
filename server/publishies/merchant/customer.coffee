Meteor.publish 'availableCustomers', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.customers.find({parentMerchant: myProfile.parentMerchant})

Schema.customers.allow
  insert: -> true
  update: -> true
  remove: -> true