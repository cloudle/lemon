scope = logics.import

lemon.defineApp Template.import,
  creationMode: -> Session.get("importCreationMode")
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  showAddDetail: -> !Session.get("currentImport")?.submitted
  showFilterSearch: -> Session.get("importManagementSearchFilter")?.length > 0
  showEditImportCurrentProduct: ->
    if product = Session.get('importCurrentProduct')
      if product.price > 0 and product.importPrice > 0
        if Session.get('showEditProduct') then true else false
      else true
    else false
  unitName: -> if @unit then @unit.unit else @product.basicUnit
  showEditProductCommand: ->
#    if currentImport = Session.get('currentImport')
#      if @unit
#        if currentImport.currentUnit is @unit._id then true else false
#      else if !currentImport.currentUnit
#        if @product._id is currentImport.currentProduct then true else false
  productSelectionActiveClass: ->
    if currentImport = Session.get('currentImport')
      if @unit
        if currentImport.currentUnit is @unit._id then 'active' else ''
      else if !currentImport.currentUnit
        if @product._id is currentImport.currentProduct then 'active' else ''

  created: ->
    lemon.dependencies.resolve('importManagement')
    Session.set("importManagementSearchFilter", "")
    if Session.get("mySession")
      if currentImport = Schema.imports.findOne(Session.get("mySession").currentImport)
        Session.set('currentImport', currentImport)
        Meteor.subscribe('importDetails', currentImport._id)

        Session.set('importCurrentProduct', Schema.products.findOne currentImport.currentProduct)
        scope.currentImportDetails = ImportDetail.findBy(currentImport._id)

#  rendered: ->
#    logics.import.templateInstance = @
#    @ui.$depositCash.inputmask("numeric", {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
#    @ui.$depositCash.val Session.get('currentImport')?.deposit ? 0

  events:
#    "click .add-product": (event, template) -> $(template.find '#addProduct').modal()
#    "click .add-provider": (event, template) -> $(template.find '#addProvider').modal()
#    "click .add-distributor": (event, template) -> $(template.find '#addDistributor').modal()
#    "click .importHistory": (event, template) -> Router.go('/importHistory')
#    "change [name='advancedMode']": (event, template) ->
#      scope.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked
#    'blur .description': (event, template)->
#      scope.updateDescriptionOfImport(template.find(".description").value, Session.get('currentImport'))
#    'click .createImportDetail': (event, template)-> scope.addImportDetail(event, template)

    "click .print-command": -> window.print()

    "click .createProductBtn": (event, template) -> scope.createProduct(template)
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("importManagementSearchFilter", template.ui.$searchFilter.val())
      , "importManagementSearchProduct"

    "keypress input[name='searchFilter']": (event, template)->
      scope.createProduct(template) if event.which is 13 and Session.get("importManagementSearchFilter")?.trim().length > 1

    "click .enableEditProduct": -> Session.set('showEditProduct', !Session.get('showEditProduct'))
    "click .product-selection": (event, template) ->
      if currentImport = Session.get('currentImport')
        currentImport.currentProduct = @product._id
        if @unit then currentImport.currentUnit = @unit._id
        else (delete currentImport.currentUnit if currentImport.currentUnit)

        if currentImport.currentUnit
          Schema.imports.update currentImport._id, $set: {currentProduct: currentImport.currentProduct, currentUnit: currentImport.currentUnit}
        else
          Schema.imports.update currentImport._id, $set: {currentProduct: currentImport.currentProduct}, $unset: {currentUnit: true}


#      if currentImport = Session.get('currentImport')
#        if product = Schema.products.findOne(@_id)
#          option =
#            currentProduct     : product._id
#            currentProvider    : product.provider ? 'skyReset'
#            currentQuality     : 1
#            currentImportPrice : product.importPrice ? 0
#          if product.price > 0 and product.inStockQuality > 0
#            Schema.imports.update(Session.get('currentImport')._id, $set: option, $unset: {currentPrice: ""})
#          else
#            option.currentPrice = product.importPrice ? 0
#            Schema.imports.update(Session.get('currentImport')._id, {$set: option})
#
#          currentImport.currentProduct     = option.currentProduct
#          currentImport.currentProvider    = option.currentProvider
#          currentImport.currentQuality     = option.currentQuality
#          currentImport.currentImportPrice = option.currentImportPrice
#
#          Session.set('currentImport', currentImport)
#          Session.set('importCurrentProduct', product)
#          Session.set('importCurrentProductShowEditCommand')
#
#          $("[name=productPrice]").val(product.price)
#          $("[name=productImportPrice]").val(product.importPrice)

    'click .addImportDetail': (event, template)->
      if importDetail = Schema.importDetails.findOne(scope.addImportDetail(@))
        Session.set("importEditingRowId", importDetail._id)
        Session.set("importEditingRow", importDetail)
        $("[name=editImportQuality]").val(importDetail.unitQuality)


    'click .editImport': (event, template)->
      if currentImport = Session.get('currentImport')
        Meteor.call 'importEnabledEdit', currentImport._id, (error, result) -> if error then console.log error
    'click .submitImport': (event, template)->
      if currentImport = Session.get('currentImport')
        Meteor.call 'importSubmit', currentImport._id, (error, result) -> if error then console.log error
    'click .finishImport': (event, template)->
      if currentImport = Session.get('currentImport')
        if currentImport.submitted is false
          Meteor.call 'importSubmit', currentImport._id, (error, result) -> if error then console.log error
        Meteor.call 'importFinish', currentImport._id, (error, result) -> if error then console.log error
        Meteor.call 'reCalculateMetroSummaryTotalPayableCash'


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
