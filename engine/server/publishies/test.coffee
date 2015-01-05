Meteor.publishComposite 'merchantTestDep',
  find: ->
    currentProfile = Schema.userProfiles.findOne({user: "xdsada"})
    return EmptyQueryResult if !currentProfile
    Schema.userProfiles.find {currentMerchant: currentProfile.currentMerchant}

  children: [
    find: (customer) -> AvatarImages.find {_id: customer.avatar}
  ]

#Meteor.publishComposite 'myMerchantProfiles',
#  find: ->
#    currentProfile = Schema.userProfiles.findOne({user: @userId})
#    return EmptyQueryResult if !currentProfile
#    Schema.userProfiles.find {currentMerchant: currentProfile.currentMerchant}
#  children: [
#    find: (profile) -> Meteor.users.find {_id: profile.user}
#  ,
#    find: (profile) -> AvatarImages.find {_id: profile.avatar}
#  ]