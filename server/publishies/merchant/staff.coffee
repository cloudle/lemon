Meteor.publishComposite 'allBranchAndWarehouses', ->
  self = @
  return {
    find: ->
      myProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !myProfile
      Schema.merchants.find {$or:[{_id: myProfile.parentMerchant }, {parent: myProfile.parentMerchant}]}
    children: [
      find: (merchant) -> Schema.warehouses.find {merchant: merchant._id}
    ,
      find: (merchant) -> Schema.userProfiles.find {currentMerchant: merchant._id}
      children: [
        find: (profile, merchant) ->  Meteor.users.find {_id: profile.user}
      ]
    ]
  }