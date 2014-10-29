#formatWarehouseSearch = (item) -> "#{item.name}" if item
#formatImportSearch = (item) -> "#{item.description}" if item
#formatImportProductSearch = (item) -> "#{item.name} [#{item.skulls}]" if item
#formatImportProviderSearch = (item) -> "#{item.name}" if item
#
#reUpdateProduct = (productId)->
#  unless Session.get('currentImport')
#    Session.set 'currentImport', Import.createdByWarehouseAndSelect(Session.get('currentWarehouse')._id, {description: Sky.helpers.formatDate(1)})
#  product = Schema.products.findOne(productId)
#  if product
#    option =
#      currentProduct     : product._id
#      currentProvider    : product.provider ? 'skyReset'
#      currentQuality     : 1
#      currentImportPrice : product.importPrice ? 0
#    if product.price > 0 and product.inStockQuality > 0
#      Schema.imports.update(Session.get('currentImport')._id, $set: option, $unset: {currentPrice: ""})
#    else
#      option.currentPrice = product.importPrice ? 0
#      Schema.imports.update(Session.get('currentImport')._id, {$set: option})
#      Session.set 'currentImport', Schema.imports.findOne(Session.get('currentImport')._id)
#    $("[name=expire]").datepicker('setDate', undefined)
#    Session.set 'currentProductInstance', product
#
#runInitImportTracker = (context) ->
#  return if Sky.global.importTracker
#  Sky.global.importTracker = Tracker.autorun ->
#    if Session.get('currentWarehouse')?._id
#      importHistory = Schema.imports.find({
#        warehouse : Session.get('currentWarehouse')._id
#        creator   : Meteor.userId()
#        submitted  : false
#      }).fetch()
#
#      if importHistory
#        if importHistory.length > 0
#          Session.set('importHistory', importHistory)
#        else
##        currentImport = Import.createdByWarehouseAndSelect(Session.get('currentProfile').currentWarehouse, {description: 'New Import'})
#
#    if Session.get('importHistory') and Session.get('currentProfile')?.currentImport
#      currentImport =  _.findWhere(Session.get('importHistory'), {_id: Session.get('currentProfile').currentImport})
#      unless currentImport then currentImport = importHistory[0]
#      Session.set 'currentImport', Schema.imports.findOne(currentImport?._id)
#      Session.set 'currentImportDetails', Schema.importDetails.find({import: currentImport?._id}).fetch()
#
#    if currentProductId = Session.get('currentImport')?.currentProduct
#      if currentProduct = Schema.products.findOne(currentProductId)
#        Session.setDefault 'currentProductInstance', currentProduct

lemon.defineApp Template.import,
#  warehouseImport: -> Session.get 'currentImport'
#  hideAddImportDetail: -> return "display: none" if Session.get('currentImport')?.finish == true
#  hidePrice: -> return "display: none" unless Session.get('currentImport')?.currentPrice >= 0
#  hideFinishImport: -> return "display: none" if Session.get('currentImport')?.finish == true || !(Session.get('currentImportDetails')?.length > 0)
#  hideEditImport: -> return "display: none" if Session.get('currentImport')?.finish == false
#  hideSubmitImport: -> return "display: none" if Session.get('currentImport')?.submitted == true


  rendered: ->
#    runInitImportTracker()
#
#    $(@find '#productPopover').modalPopover
#      target: '#popProduct'
#      backdrop: true
#      placement: 'bottom'
#
#    $(@find '#providerPopover').modalPopover
#      target: '#popProvider'
#      backdrop: true
#      placement: 'bottom'


  events:
    "click #popProduct": (event, template) -> $(template.find '#productPopover').modalPopover('show')
    "click #popProvider": (event, template) -> $(template.find '#providerPopover').modalPopover('show')

    'click .addImportDetail': (event, template)-> logics.imports.addImportDetail(event, template, currentImport)
    'click .editImport': (event, template)-> logics.imports.enabledEdit(currentImport._id)


    'click .finishImport': (event, template)->
      console.log Import.finishImport Session.get('currentImport')._id

    'click .submitImport': (event, template)->
      console.log Import.submittedImport Session.get('currentImport')._id
      unless Schema.imports.findOne({_id: Session.get('currentImport')._id, submitted: false})
        Session.set 'currentImport', Import.createdByWarehouseAndSelect(Session.get('currentWarehouse')._id, {description: Sky.helpers.formatDate(1)})

    'blur .description': (event, template)->logics.imports.updateDescription(template.find(".description").value, currentImportId)
    'blur .deposit': (event, template)->logics.imports.updateDeposit(template.find(".description").value, currentImportId)



#  tabOptions             : logics.imports.tabOptions()
#  importDetailOptions    : logics.imports.importDetailOptions()
#  warehouseSelectOptions : logics.imports.warehouseSelectOptions()
#  productSelectOptions   : logics.imports.productSelectOptions()
#  providerSelectOptions  : logics.imports.providerSelectOptions()
#  qualityOptions         : logics.imports.qualityOptions()
#  importPriceOptions     : logics.imports.importPriceOptions()
#  priceOptions           :logics.imports.priceOptions()


