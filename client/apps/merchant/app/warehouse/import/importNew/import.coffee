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
      deposit = template.find(".deposit")
      currentImport = Session.get('currentImport')
      if currentImport.totalPrice < deposit.value
        deposit.value = currentImport.totalPrice
        if currentImport.debit != currentImport.deposit
          logics.import.updateDeposit(currentImport.totalPrice , currentImport)
      else
        logics.import.updateDeposit(deposit.value , currentImport)

    'click .addImportDetail': (event, template)-> logics.import.addImportDetail(event, template)

    'click .editImport': (event, template)->
      if currentImport = Session.get('currentImport')
        Meteor.call 'importEnabledEdit', currentImport._id, (error, result) -> if error then console.log error.error

    'click .submitImport': (event, template)->
      if currentImport = Session.get('currentImport')
        Meteor.call 'importSubmit', currentImport._id, (error, result) -> if error then console.log error.error

    'click .finishImport': (event, template)->
      if currentImport = Session.get('currentImport')
        if currentImport.submitted is false
          Meteor.call 'importSubmit', currentImport._id, (error, result) -> if error then console.log error.error
        Meteor.call 'importFinish', currentImport._id, (error, result) -> if error then console.log error.error
    'click .excel-import': (event, template) -> $(".excelFileSource").click()

    'change .excelFileSource': (event, template) ->
      if event.target.files.length > 0
        console.log 'importing'
        $excelSource = $(".excelFileSource")
        $excelSource.parse
          config:
            complete: (results, file) ->
              console.log file
              console.log results
              if file.type is "text/csv"
                Apps.Merchant.exportFileImport(results.data)

        $excelSource.val("")
