Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.returnQualityOptions =
    reactiveSetter: (val) ->
      Schema.sales.update(Session.get('currentSale')._id, {$set: {currentQuality: val}})
    reactiveValue: -> Session.get('currentSale')?.currentQuality ? 0
    reactiveMax: -> Session.get('currentMaxQualityReturn') ? 0
    reactiveMin: -> if Session.get('currentMaxQualityReturn') > 0 then 1 else 0
    reactiveStep: -> 1