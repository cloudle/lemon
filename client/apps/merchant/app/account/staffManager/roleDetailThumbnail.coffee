lemon.defineWidget Template.roleDetailThumbnail,
  permissionDesc: ->
    return 'CHƯA PHÂN QUYỀN' if !@roles
    Schema.roles.findOne({name: @roles[0]})?.description ? 'KHÔNG TÌM THẤY'
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  email: ->
    Meteor.users.findOne(@user).emails[0].address
