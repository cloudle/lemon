logics.import.tabOptions =
  source: Schema.imports.find({creator: Meteor.userId()})
  currentSource: 'currentImport'
  caption: 'description'
  key: '_id'
  createAction  : -> Import.createdBy(Session.get('myProfile').currentWarehouse, {description: '01-05-2015'})
  destroyAction : (instance) ->
#console.log Import.removeAll(instance._id)
  navigateAction: (instance) ->
#    UserProfile.update {currentImport: instance._id}
#    currentImport = Schema.imports.findOne(instance._id)
#    reUpdateProduct(currentImport.currentProduct)