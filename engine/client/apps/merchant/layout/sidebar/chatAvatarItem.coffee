lemon.defineWidget Template.chatAvatarItem,
  alias: ->
    alias = @fullName ? Meteor.users.findOne(@user)?.emails[0].address
    return {
      shortName: Helpers.shortName(alias)
      firstName: Helpers.firstName(alias)
    }
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined

  hasUnreadMessage: ->
    return '' if @user is Meteor.userId()
    result = Schema.messages.findOne { $and: [{sender: @user}, {reads: {$ne: Meteor.userId()}}] }
    if result then 'active' else ''