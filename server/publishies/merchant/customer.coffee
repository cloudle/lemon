Meteor.publish 'customers', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.customers.find({parentMerchant: myProfile.parentMerchant},
    {fields: {name: 1, phone: 1, address: 1, gender: 1}})
Schema.customers.allow
  insert: -> true
  update: -> true
  remove: -> true