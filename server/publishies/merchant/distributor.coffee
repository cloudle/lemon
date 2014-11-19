Meteor.publish 'distributors', ->
  myProfile = Schema.userProfiles.findOne({user: @userId})
  return [] if !myProfile
  Schema.distributors.find({parentMerchant: myProfile.parentMerchant})

Schema.distributors.allow
  insert: (userId, distributor)-> true
  update: (userId, distributor)-> true
  remove: (userId, distributor)->
    if distributor.allowDelete
      if Schema.imports.findOne({distributor: distributor._id}) then false else true