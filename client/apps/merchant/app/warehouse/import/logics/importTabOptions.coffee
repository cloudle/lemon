#logics.imports.tabOptions =
#  source: 'importHistory'
#  currentSource: 'currentImport'
#  caption: 'description'
#  key: '_id'
#  createAction  : -> Import.createdByWarehouseAndSelect(Session.get('currentWarehouse')._id, {description: Sky.helpers.formatDate(1)})
#  destroyAction : (instance) -> console.log Import.removeAll(instance._id)
#  navigateAction: (instance) ->
#    UserProfile.update {currentImport: instance._id}
#    currentImport = Schema.imports.findOne(instance._id)
#    reUpdateProduct(currentImport.currentProduct)