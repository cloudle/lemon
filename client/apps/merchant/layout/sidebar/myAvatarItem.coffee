lemon.defineWidget Template.myAvatarItem,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined

  events:
    "click": (event, template) -> template.find('.avatarFileSelector').click()
    "change .avatarFileSelector": (event, template)->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          console.log error, fileObj
          Schema.userProfiles.update(Apps.myProfile._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Apps.myProfile.avatar)?.remove()