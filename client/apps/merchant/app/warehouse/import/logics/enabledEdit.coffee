Apps.Merchant.importInit.push (scope) ->
  logics.import.enabledEdit = (importId) ->
    currentImport = Schema.imports.findOne({_id: importId, finish: true, submitted: false})
    if currentImport
      importDetails = Schema.importDetails.find({import: importId}).fetch()
      if importDetails.length > 0
        for importDetail in importDetails
          ImportDetail.update importDetail._id, $set: {finish: false}
        Import.update importId, $set:{finish: false}
        console.log 'Phieu Co The Duoc Chinh Sua'