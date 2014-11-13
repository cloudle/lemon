lemon.defineApp Template.import,
  rendered: -> logics.import.templateInstance = @
  events:
    "click .add-product": (event, template) -> $(template.find '#addProduct').modal()
    "click .add-provider": (event, template) -> $(template.find '#addProvider').modal()

    "click .importHistory": (event, template) -> Router.go('/importHistory')
    "change [name='advancedMode']": (event, template) ->
      logics.import.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    'blur .description': (event, template)->
      logics.import.updateDescription(template.find(".description").value, Session.get('currentImport'))

    'blur .deposit': (event, template)->
      deposit = template.find(".deposit").value
      if deposit >= 0 then logics.import.updateDeposit(deposit, Session.get('currentImport'))

    'click .addImportDetail': (event, template)-> logics.import.addImportDetail(event, template)

    'click .editImport': (event, template)->
      if currentImport = Session.get('currentImport')
        Meteor.call 'importEnabledEdit', currentImport._id, (error, result) ->
          if error then console.log error.error else console.log result

    'click .submitImport': (event, template)->
      if currentImport = Session.get('currentImport')
        Meteor.call 'importSubmit', currentImport._id, (error, result) ->
          if error then console.log error.error else console.log result

    'click .finishImport': (event, template)->
      if currentImport = Session.get('currentImport')
        if currentImport.submitted is false
          Meteor.call 'importSubmit', currentImport._id, (error, result) ->
            if error then console.log error.error else console.log results
        Meteor.call 'importFinish', currentImport._id, (error, result) ->
          if error then console.log error.error else console.log result