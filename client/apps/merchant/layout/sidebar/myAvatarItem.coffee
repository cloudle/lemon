lemon.defineWidget Template.myAvatarItem,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined

  events:
    "click": (event, template) -> console.log template.find('.avatarFileSelector').click()
    "change .avatarFileSelector": (event, template)->
      currentProfile = Session.get('currentProfile')
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.userProfiles.update(currentProfile._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(currentProfile.avatar)?.remove()