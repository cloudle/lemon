reactiveMinSalePrice = ->
  if Session.get('currentImport')?.currentPrice
    Session.get('currentImport')?.currentImportPrice
  else
    Number(0)

Apps.Merchant.importInit.push (scope) ->
  logics.import.salePriceOptions =
    reactiveSetter: (val) -> Import.update(Session.get('currentImport')._id, {$set: {currentPrice: val}})
    reactiveValue: -> Session.get('currentImport')?.currentPrice ? 0
    reactiveMax: -> 9999999999
    reactiveMin: -> reactiveMinSalePrice()
    reactiveStep: -> 1000
    others:
      forcestepdivisibility: 'none'