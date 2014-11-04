Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.discountCashOptions =
    reactiveSetter: (val)->
      option = {discountCash : val}
      if val > 0 then option.discountPercent = val/(Session.get('currentReturn').totalPrice)*100
      else option.discountPercent = 0

      option.finallyPrice = Session.get('currentReturn').totalPrice - option.discountCash
      Schema.returns.update(Session.get('currentReturn')._id, {$set: option}) if Session.get('currentReturn')
    reactiveValue: -> Session.get('currentReturn')?.discountCash ? 0
    reactiveMax: ->  Session.get('currentReturn')?.totalPrice ? 0
    reactiveMin: -> 0
    reactiveStep: -> 1000
    others:
      forcestepdivisibility: 'none'