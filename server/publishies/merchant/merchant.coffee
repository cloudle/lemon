#Meteor.publish 'myMerchant', ->
#  myProfile = Schema.userProfiles.findOne({user: @userId})
#  return [] if !myProfile
#  Schema.merchants.find({_id: myProfile.currentMerchant})
#
#Schema.merchants.allow
#  insert: -> true
#  update: -> true
#  remove: -> true