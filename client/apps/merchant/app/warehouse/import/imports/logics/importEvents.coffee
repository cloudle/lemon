Apps.Merchant.importInit.push (scope) ->
  logics.import.updateDescription = (description, currentImport) ->
    if currentImport.finish is false and currentImport.submitted is false
      if description.length > 1
        Schema.imports.update(currentImport._id, {$set: {description: description}})
      else
        description = currentImport.description


  logics.import.updateDeposit = (deposit, currentImport) ->
    if currentImport.finish is false and currentImport.submitted is false
      if parseInt(deposit) > 0
        if parseInt(deposit) > currentImport.totalPrice then deposit = currentImport.totalPrice
        option = {deposit: parseInt(deposit), debit: 0}
      else
        deposit = 0
        option ={ deposit: 0, debit: currentImport.totalPrice}
      Import.update(currentImport._id, {$set: option})
