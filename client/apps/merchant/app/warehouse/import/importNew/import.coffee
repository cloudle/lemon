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
              console.log results
              console.log file
              if file.type is "text/csv"
                data = results.data
                #kiem tra nha cung cap
                for item, index in data
                  if index != 0
                    if !Schema.providers.findOne({parentMerchant: Session.get('myProfile').parentMerchant, name: item[3]})
                      Provider.createNew(item[3])

                #kiem tra san pham
                for item, index in data
                  if index != 0
                    if !Schema.products.findOne({
                      merchant    : Session.get('myProfile').currentMerchant
                      warehouse   : Session.get('myProfile').currentWarehouse
                      productCode : item[0]
                      skulls      : item[2]
                    }) then Product.createNew(item[0], item[1], [item[2]], Session.get('myProfile').currentWarehouse)

                #them san pham vao phieu
                for item, index in data
                  if index != 0
                    importId = logics.import.currentImport._id
                    productId = Schema.products.findOne({
                      merchant    : Session.get('myProfile').currentMerchant
                      warehouse   : Session.get('myProfile').currentWarehouse
                      productCode : item[0]
                      skulls      : item[2]
                    })._id
                    providerId = Schema.providers.findOne({parentMerchant: Session.get('myProfile').parentMerchant, name: item[3]})._id
                    quality = item[4]
                    price = item[5]
                    priceSale = null
                    productionDate = null
                    timeUse = null
                    ImportDetail.new(importId, productId, quality, price, providerId, priceSale, productionDate, timeUse)
                    
        $excelSource.val("")
