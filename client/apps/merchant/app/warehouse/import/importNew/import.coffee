lemon.defineApp Template.import,
  rendered: -> logics.import.templateInstance = @
  events:
    "click .add-product": (event, template) -> $(template.find '#addProduct').modal()
    "click .add-provider": (event, template) -> $(template.find '#addProvider').modal()

    "click .importHistory": (event, template) -> Router.go('/importHistory')
    "change [name='advancedMode']": (event, template) ->
      logics.import.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    'click .addImportDetail': (event, template)-> logics.import.addImportDetail(event, template)
    'click .finishImport'   : (event, template)->
      if Session.get('currentImport')?.submitted is false
        logics.import.submit(Session.get('currentImport')._id)
      logics.import.finish(Session.get('currentImport')._id)
    'click .editImport'     : (event, template)-> logics.import.enabledEdit(Session.get('currentImport')._id)
    'click .submitImport'   : (event, template)-> logics.import.submit(Session.get('currentImport')._id)
    'blur .description'     : (event, template)-> logics.import.updateDescription(template.find(".description").value, Session.get('currentImport'))
    'blur .deposit'         : (event, template)->
      deposit = template.find(".deposit").value
      if deposit >= 0 then logics.import.updateDeposit(deposit, Session.get('currentImport'))


