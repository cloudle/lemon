lemon.defineWidget Template.chatAvatarItem,
  shortAlias: -> Helpers.shortName(@fullName ? Meteor.users.findOne(@user)?.emails[0].address)
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined

  hasUnreadMessage: ->
    return '' if @user is Meteor.userId()
    result = Schema.messages.findOne { $and: [{sender: @user}, {reads: {$ne: Meteor.userId()}}] }
    if result then 'active' else ''