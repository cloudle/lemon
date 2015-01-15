scope = logics.geraProductGroup

lemon.defineHyper Template.geraProductGroupOverviewSection,
  avatarUrl        : -> if @image then AvatarImages.findOne(@image)?.url() else undefined
  showEditCommand  : -> Session.get "geraProductGroupShowEditCommand"
  showDeleteCommand: -> Session.get('geraProductGroupCurrentProductGroup')?.allowDelete

  name: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$productName.change()
    , 50 if scope.overviewTemplateInstance
    @name
  description: ->
    Meteor.setTimeout ->
      scope.overviewTemplateInstance.ui.$description.change()
    , 50 if scope.overviewTemplateInstance
    @description


  rendered: ->
    scope.overviewTemplateInstance = @
    @ui.$productName.autosizeInput({space: 10})
#    @ui.$description.autosizeInput({space: 10})

  events:
    "click .avatar": (event, template) -> template.find('.avatarFile').click()
    "change .avatarFile": (event, template) ->
      files = event.target.files
      if files.length > 0
        AvatarImages.insert files[0], (error, fileObj) ->
          Schema.productGroups.update(Session.get('geraProductGroupCurrentProductGroup')._id, {$set: {image: fileObj._id}})
          AvatarImages.findOne(Session.get('geraProductGroupCurrentProductGroup').image)?.remove()

    "click .syncProductEdit": (event, template)-> scope.updateGeraProductGroup(template)
    "click .productDelete": (event, template) -> scope.deleteGeraProductGroup(@)
    "keyup input.editable": (event, template) -> scope.checkAndUpdateGeraProductGroup(event, template)

    "input .editable": (event, template) ->
      Session.set "geraProductGroupShowEditCommand",
        template.ui.$productName.val() isnt Session.get("geraProductGroupCurrentProductGroup").name or
        template.ui.$description.val() isnt Session.get("geraProductGroupCurrentProductGroup").description

