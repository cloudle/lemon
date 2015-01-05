Meteor.publish 'merchantProductCount', ->
  profile = Schema.userProfiles.findOne({user: @userId})
  return [] if !profile

  Counts.publish @, 'name-of-counter', Schema.products.find({warehouse: profile.currentWarehouse})
  return