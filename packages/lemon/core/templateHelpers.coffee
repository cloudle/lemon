Template.registerHelper 'systemVersion', -> Schema.systems.findOne()?.version ? '?'
Template.registerHelper 'appCollapseClass', -> if Session.get('collapse') then 'icon-angle-double-left' else 'icon-angle-double-right'

Template.registerHelper 'sessionGet', (name) -> Session.get(name)
Template.registerHelper 'authenticated', (name) -> Meteor.userId() isnt null
Template.registerHelper 'metroUnLocker', (context) ->  if context < 1 then 'locked'
Template.registerHelper 'formatNumber', (context) ->  accounting.formatNumber(context)
Template.registerHelper 'formatNumberK', (context) ->  accounting.formatNumber(context/1000)

Template.registerHelper 'pad', (number) -> if number < 10 then '0' + number else number
Template.registerHelper 'round', (number) -> Math.round(number)
Template.registerHelper 'momentFormat', (date, format) -> moment(date).format(format)

Template.registerHelper 'productNameFromId', (id) -> Schema.products.findOne(id)?.name
Template.registerHelper 'productCodeFromId', (id) -> Schema.products.findOne(id)?.productCode
Template.registerHelper 'skullsNameFromId', (id) -> Schema.products.findOne(id)?.skulls
Template.registerHelper 'userNameFromId', (id) -> Schema.userProfiles.findOne({user: id})?.fullName ? Meteor.users.findOne(id)?.emails[0].address
Template.registerHelper 'ownerNameFromId', (id) -> Schema.customers.findOne(id)?.name

Template.registerHelper 'aliasLetter', (fullAlias) -> fullAlias?.split(' ').pop().substring(0,1)

Template.registerHelper 'activeClassByCount', (count) -> if count > 0 then 'active' else ''
Template.registerHelper 'onlineStatus', (userId)->
  currentUser = Meteor.users.findOne(userId)
  if currentUser?.status?.online
    return 'online'
  else if currentUser?.status?.idle
    return 'idle'
  else
    return 'offline'

#Notifications----------------------------------------------->
Template.registerHelper 'notificationSenderAvatar', ->
  profile = Schema.userProfiles.findOne({user: @sender})
  return undefined if !profile?.avatar
  AvatarImages.findOne(profile.avatar)?.url()
Template.registerHelper 'notificationSenderAlias', ->
  Schema.userProfiles.findOne({user: @sender})?.fullName ? '?'
