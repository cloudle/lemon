logics.imports.priceOptions = ->
  reactiveSetter: (val) ->
    if Session.get('currentImport').currentPrice
      Schema.imports.update(Session.get('currentImport')._id, {$set: { currentPrice: val }})
  reactiveValue: -> Session.get('currentImport')?.currentPrice ? 0
  reactiveMax: -> 999999999
  reactiveMin: ->
    if Session.get('currentImport')?.currentPrice
      return Session.get('currentImport')?.currentImportPrice
    else
      Number(0)
  reactiveStep: -> 1000
  others:
    forcestepdivisibility: 'none'