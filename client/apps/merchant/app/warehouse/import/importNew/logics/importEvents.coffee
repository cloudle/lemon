Apps.Merchant.importInit.push (scope) ->
  logics.import.updateDescriptionOfImport = (description, currentImport) ->
    if currentImport.finish is false and currentImport.submitted is false
      if description.length > 1
        Schema.imports.update(currentImport._id, {$set: {description: description}})
      else
        description = currentImport.description

  logics.import.calculateImportByDeposit = (deposit, currentImport) ->
    if currentImport.finish is false and currentImport.submitted is false
      if deposit > 0
        if deposit > currentImport.totalPrice then option = {deposit: currentImport.totalPrice, debit: 0}
        else option = {deposit: deposit, debit: currentImport.totalPrice - deposit}
      else
        option = {deposit: 0, debit: currentImport.totalPrice}
      Schema.imports.update(currentImport._id, {$set: option})