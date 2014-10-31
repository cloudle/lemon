Apps.Merchant.importInit.push (scope) ->
  logics.import.finish = (importId) ->
    currentImport = Schema.imports.findOne({_id: importId, finish: false, submitted: false})
    if currentImport
      importDetails = Schema.importDetails.find({import: importId}).fetch()
      if importDetails.length > 0
        for importDetail in importDetails
          ImportDetail.update importDetail._id, $set: {finish: true}
        Import.update importId, $set:{finish: true}
        console.log 'Duoc Xac Nhan, Cho Duyet Cua Quan Ly'
