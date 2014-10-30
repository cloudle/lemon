calculateImportPrice =(val)->
#  currentImport = Session.get('currentImport')
#  if currentImport.currentPrice >= 0
#    if currentImport.currentPrice == currentImport.currentImportPrice || currentImport.currentPrice < val
#      Schema.imports.update(Session.get('currentImport')._id, {$set: {currentImportPrice: val, currentPrice: val}})
#  else
#    Schema.imports.update(Session.get('currentImport')._id, {$set: {currentImportPrice: val}})
#  Session.set 'currentImport', Schema.imports.findOne(Session.get('currentImport')._id)
#  Schema.products.update(Session.get('currentImport').currentProduct, {$set:{importPrice: val}})


logics.import.importPriceOptions =
  reactiveSetter: (val) -> calculateImportPrice(val)
  reactiveValue: -> 0 ? 0
  reactiveMax: -> 999999999
  reactiveMin: -> 0
  reactiveStep: -> 1000
  others:
    forcestepdivisibility: 'none'