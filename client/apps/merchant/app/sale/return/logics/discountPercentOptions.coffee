Apps.Merchant.returnsInit.push (scope) ->
  logics.returns.discountPercentOptions =
    reactiveSetter: (val) ->
      option = {discountPercent : val}
      if val > 0 then option.discountCash = Math.round((logics.returns.currentReturn.totalPrice)/100*val)
      else option.discountCash = 0

      option.finallyPrice = logics.returns.currentReturn.totalPrice - option.discountCash
      Schema.returns.update(logics.returns.currentReturn._id, {$set: option}) if logics.returns.currentReturn
    reactiveValue: -> if returns = logics.returns.currentReturn then Math.round(returns.discountPercent) else 0
    reactiveMax: -> if Session.get('currentReturn') then 100 else 0
    reactiveMin: -> 0
    reactiveStep: -> 1
