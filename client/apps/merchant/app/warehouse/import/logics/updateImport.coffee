logics.imports.updateDescription = (description, currentImport) ->
  if description.length > 1
    Schema.imports.update(currentImport._id, {$set: {description: description}})
  else
    description = currentImport.description

logics.imports.updateDeposit = (deposit, currentImport) ->
  if parseInt(deposit) > 0
    if parseInt(deposit) > currentImport.totalPrice then deposit = currentImport.totalPrice
    option = {deposit: parseInt(deposit), debit: 0}
  else
    deposit = 0
    option ={ deposit: 0, debit: currentImport.totalPrice}

  Schema.imports.update(currentImport._id, {$set: option})
