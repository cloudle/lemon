scope = logics.import

lemon.defineApp Template.import,
  showFilterSearch: -> Session.get("importManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  firstName: -> Helpers.firstName(@name)
  productSelectionActiveClass:-> if Session.get('currentImport')?.currentProduct is @._id then 'active' else ''
  product: -> Schema.products.findOne(@product)
  showHistory: -> Session.get("metroSummary")?.importCount > 0

  creationMode: -> Session.get("importCreationMode")
  showEditImportCurrentProduct: -> Session.get('importCurrentProduct').allowDelete

  rendered: ->
    logics.import.templateInstance = @
    @ui.$depositCash.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
    @ui.$debitCash.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})


  created: ->
    lemon.dependencies.resolve('importManagement')
    Session.set("importManagementSearchFilter", "")
#    if Session.get("mySession")
#      currentImport = Session.get("mySession").currentImport  ManagementSelection
#      if !currentImport
#        if  = Schema.customers.findOne()

  events:
    "input .search-filter": (event, template) ->
      Session.set("importManagementSearchFilter", template.ui.$searchFilter.val())
    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get("importManagementSearchFilter")?.trim().length > 1
        scope.createProduct(template)
    "click .createProductBtn": (event, template) -> scope.createProduct(template)


    "click .inner.caption": (event, template) ->
      if currentImport = Session.get('currentImport')
        if product = Schema.products.findOne(@_id)
          option =
            currentProduct     : product._id
            currentProvider    : product.provider ? 'skyReset'
            currentQuality     : 1
            currentImportPrice : product.importPrice ? 0
          if product.price > 0 and product.inStockQuality > 0
            Schema.imports.update(Session.get('currentImport')._id, $set: option, $unset: {currentPrice: ""})
          else
            option.currentPrice = product.importPrice ? 0
            Schema.imports.update(Session.get('currentImport')._id, {$set: option})

          currentImport.currentProduct     = option.currentProduct
          currentImport.currentProvider    = option.currentProvider
          currentImport.currentQuality     = option.currentQuality
          currentImport.currentImportPrice = option.currentImportPrice

          Session.set('importCurrentProduct', product)
          Session.set('currentImport', currentImport)
          Session.set('importCurrentProductShowEditCommand')

#          $("[name=productionDate]").datepicker('setDate', undefined)

    "click .add-product": (event, template) -> $(template.find '#addProduct').modal()
    "click .add-provider": (event, template) -> $(template.find '#addProvider').modal()
    "click .add-distributor": (event, template) -> $(template.find '#addDistributor').modal()

    "click .importHistory": (event, template) -> Router.go('/importHistory')
    "change [name='advancedMode']": (event, template) ->
      scope.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    'blur .description': (event, template)->
      scope.updateDescriptionOfImport(template.find(".description").value, Session.get('currentImport'))

    'blur .deposit': (event, template)->
      if currentImport = Session.get('currentImport')
        deposit = $(template.find(".deposit")).inputmask('unmaskedvalue')
        if currentImport.totalPrice < deposit
          if currentImport.debit != currentImport.deposit
            logics.import.calculateImportByDeposit(currentImport.totalPrice , currentImport)
        else
          logics.import.calculateImportByDeposit(deposit, currentImport)

    'click .addImportDetail': (event, template)-> scope.addImportDetail(event, template)

    'click .createImportDetail': (event, template)-> scope.addImportDetail(event, template)

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
#              if file.name is "nhap_kho.csv"
#              if file.type is "text/csv" || file.type is "application/vnd.ms-excel"
              logics.import.importFileProductCSV(results.data)


        $excelSource.val("")
