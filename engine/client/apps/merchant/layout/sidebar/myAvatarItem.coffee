lemon.defineWidget Template.myAvatarItem,
  alias: ->
    alias = @fullName ? Meteor.users.findOne(@user)?.emails[0].address
    return {
      shortName: Helpers.shortName(alias)
      firstName: Helpers.firstName(alias)
    }
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined

  events:
    "click .avatar": (event, template) -> template.find('.avatarFileSelector').click()
    "change .avatarFileSelector": (event, template)->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          console.log error, fileObj
          Schema.userProfiles.update(Session.get('myProfile')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('myProfile').avatar)?.remove()