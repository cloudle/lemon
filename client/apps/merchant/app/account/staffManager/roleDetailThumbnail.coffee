lemon.defineWidget Template.roleDetailThumbnail,
  permissionDesc: ->
    return 'CHƯA PHÂN QUYỀN' if !@roles
    Schema.roles.findOne({name: @roles[0]})?.description ? 'KHÔNG TÌM THẤY'
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  email: -> Meteor.users.findOne(@user)?.emails[0].address

  allowDelete: ->
    if @allowDelete
      if user = Meteor.users.findOne(@user)?.status
        if user.online then false else true
      else true


  events:
    "click .trash": (event, template) ->
      if Meteor.users.findOne(@user).status?.online then return
      if @user isnt Meteor.userId()
        if Meteor.users.remove(@user) is 1
          Schema.userProfiles.remove(@_id)
          Schema.userSessions.remove(userSession._id) if userSession = Schema.userSessions.findOne({user: @user})
          Schema.userOptions.remove(userOption._id) if userOption = Schema.userOptions.findOne({user: @user})
