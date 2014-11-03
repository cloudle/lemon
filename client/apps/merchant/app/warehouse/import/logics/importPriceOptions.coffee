calculateImportPrice =(val)->
  option = {currentImportPrice: val}
  if Session.get('currentImport')?.currentPrice < val then option.currentPrice = val
  Import.update(Session.get('currentImport')?._id, {$set: option})
  Product.update(Session.get('currentImport')?.currentProduct, {$set:{importPrice: val}})

Apps.Merchant.importInit.push (scope) ->
  console.log
  logics.import.importPriceOptions =
    reactiveSetter: (val) -> calculateImportPrice(val)
    reactiveValue: -> Session.get('currentImport')?.currentImportPrice ? 0
    reactiveMax: -> 9999999999
    reactiveMin: -> 0
    reactiveStep: -> 1000
    others:
      forcestepdivisibility: 'none'