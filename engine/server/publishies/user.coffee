Meteor.publish 'myProfile', -> Schema.userProfiles.find({user: @userId})

Meteor.publishComposite 'myMerchantUserProfiles', ->
  self = @
  return {
    find: ->
      currentProfile = Schema.userProfiles.findOne({user: self.userId})
      return EmptyQueryResult if !currentProfile
      Schema.userProfiles.find {currentMerchant: currentProfile.currentMerchant}
    children: [
      find: (profile) -> Meteor.users.find {_id: profile.user}
    ,
      find: (profile) -> AvatarImages.find {_id: profile.avatar}
    ]
  }

Meteor.publish 'myOption', -> Schema.userOptions.find({user: @userId})
Meteor.publish 'mySession', -> Schema.userSessions.find({user: @userId})

Meteor.users.allow
  insert: (userId, user)-> true
  update: (userId, user)-> true
  remove: (userId, user)->
    if userId is user._id or user.isRoot is true then return false
    if Meteor.users.findOne(user._id).status?.online then return false
    if Schema.orders.findOne {creator: user._id} then return false
    if Schema.orders.findOne {seller: user._id} then return false
    if Schema.sales.findOne {creator: user._id} then return false
    if Schema.sales.findOne {seller: user._id} then return false
    if Schema.imports.findOne {creator: user._id} then return false
    if Schema.customers.findOne {creator: user._id} then return false
    MetroSummary.updateMetroSummaryByStaffDestroy(userId)
    return true

Schema.userProfiles.allow
  insert: (userId, userProfile)-> true
  update: (userId, userProfile)-> true
  remove: (userId, userProfile)-> if Meteor.users.findOne(userProfile.user) then false else true

Schema.userOptions.allow
  insert: (userId, userOption)-> true
  update: (userId, userOption)-> true
  remove: (userId, userOption)-> if Meteor.users.findOne(userOption.user) then false else true

Schema.userSessions.allow
  insert: (userId, userSession) -> return userSession.user is userId and Schema.userSessions.findOne({user: userId}) is undefined
  update: (userId, userSession) -> return userSession.user is userId
  remove: (userId, userSession) -> if Meteor.users.findOne(userSession.user) then false else true
