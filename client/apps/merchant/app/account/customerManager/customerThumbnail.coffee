lemon.defineWidget Template.customerThumbnail,
  gender: -> if @gender then 'Nam' else 'Nữ'
  isntDelete: -> unless Schema.sales.findOne({buyer: @_id}) then true
  dateOfBirth: -> @dateOfBirth?.toDateString()
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  events:
    "click .trash": (event, template) ->
      Schema.customers.remove(@_id)
      MetroSummary.updateMetroSummaryBy(['customer'])
      event.stopPropagation()
    "click .avatar": (event, template) ->
      template.find('.avatarFile').click()
      Session.set('currentCustomer', @instance)
      event.stopPropagation()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.customers.update(Session.get('currentCustomer')._id, {$set: {avatar: fileObj._id}})
          AvatarImages.findOne(Session.get('currentCustomer').avatar)?.remove()