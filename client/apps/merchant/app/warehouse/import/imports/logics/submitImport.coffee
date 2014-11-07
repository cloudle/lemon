Apps.Merchant.importInit.push (scope) ->
  logics.import.submit = (importId) ->
    currentImport = Schema.imports.findOne({_id: importId, finish: false, submitted: false})
    if currentImport
      importDetails = Schema.importDetails.find({import: importId}).fetch()
      if importDetails.length > 0
        for importDetail in importDetails
          Schema.importDetails.update importDetail._id, $set: {submitted: true}
        Schema.imports.update importId, $set:{submitted: true}
        console.log 'Duoc Xac Nhan, Cho Duyet Cua Quan Ly'
