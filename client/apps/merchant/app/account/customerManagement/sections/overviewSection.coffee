scope = logics.customerManagement

lemon.defineWidget Template.customerManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.customers.update(Session.get('customerManagementCurrentCustomer')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('customerManagementCurrentCustomer').avatar)?.remove()