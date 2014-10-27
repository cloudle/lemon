logics.imports.enabledEdit = (importId) ->
  currentImport = Import.findOne({_id: importId, finish: true, submitted: false})
  if currentImport
    importDetails = Schema.importDetails.find({import: importId}).fetch()
    for importDetail in importDetails
      Schema.importDetails.update importDetail._id, $set: {finish: false}
    Schema.imports.update importId, $set:{finish: false}
