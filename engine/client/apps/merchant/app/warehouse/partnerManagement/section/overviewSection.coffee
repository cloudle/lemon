scope = logics.partnerManagement

lemon.defineHyper Template.partnerManagementOverviewSection,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showEditCommand: -> Session.get "partnerManagementShowEditCommand"
  showDeleteCommand: -> Session.get('partnerManagementCurrentPartner')?.allowDelete

  name: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$partnerName.change()
    , 50 if scope.overviewTemplateInstance
    @name

  phone: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$partnerPhone.change()
    , 50 if scope.overviewTemplateInstance
    @phone

  address: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$partnerAddress.change()
    , 50 if scope.overviewTemplateInstance
    @address

  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$partnerName.autosizeInput({space: 10})
    @ui.$partnerPhone.autosizeInput({space: 10})
    @ui.$partnerAddress.autosizeInput({space: 10})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
#      files = event.target.files
#      if files.length > 0
#        AvatarImages.insert files[0], (error, fileObj) ->
#          Schema.partners.update(Session.get('partnerManagementCurrentPartner')._id, {$set: {avatar: fileObj._id}})
#          AvatarImages.findOne(Session.get('partnerManagementCurrentPartner').avatar)?.remove()

    "click .partnerDelete": ->
      Meteor.call 'updateMerchantPartner', @_id, 'delete', (error, result) ->
        if error then console.log error.error
        else
          randomParent = Schema.partners.findOne({parentMerchant: Session.get('myProfile').parentMerchant})
          UserSession.set('currentPartnerManagementSelection', randomParent._id) if randomParent

    "click .syncPartnerEdit": (event, template) ->
    "keyup input.editable": (event, template) -> scope.keyupCheckEditPartner(event, template)