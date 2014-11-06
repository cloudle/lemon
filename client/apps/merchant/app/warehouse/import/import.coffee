lemon.defineApp Template.import,
  rendered: -> logics.import.templateInstance = @
  events:
    "click .add-product": (event, template) -> $(template.find '#addProduct').modal()
    "click .add-provider": (event, template) -> $(template.find '#addProvider').modal()
    "change [name='advancedMode']": (event, template) ->
      logics.import.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    'click .addImportDetail': (event, template)-> logics.import.addImportDetail(event, template)
    'click .finishImport'   : (event, template)-> logics.import.finish(Session.get('currentImport')._id)
    'click .editImport'     : (event, template)-> logics.import.enabledEdit(Session.get('currentImport')._id)
    'click .submitImport'   : (event, template)-> logics.import.submit(Session.get('currentImport')._id)
    'blur .description'     : (event, template)->logics.import.updateDescription(template.find(".description").value, currentImportId)
    'blur .deposit'         : (event, template)->logics.import.updateDeposit(template.find(".description").value, currentImportId)


