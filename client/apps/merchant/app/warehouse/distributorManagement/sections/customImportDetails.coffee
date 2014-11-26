lemon.defineWidget Template.distributorManagementCustomImportDetails,
  isEditing: -> Session.get("distributorManagementCurrentCustomImport")?._id is @_id
  customImportDetails: ->
    customImportId = UI._templateInstance().data._id
    Schema.customImportDetails.find({customImport: customImportId})

  events:
    "click .enter-edit": (event, template) -> Session.set("distributorManagementCurrentCustomImport", @)
    "click .cancel-edit": (event, template) -> Session.set("distributorManagementCurrentCustomImport")