updateQualityCurrentProduct = (val)->
  if logics.import.currentImport
    Import.update(logics.import.currentImport._id, {$set: { currentQuality: val }})
  else
    console.log 'currentImport không tồn tại.'

logics.import.qualityOptions =
  reactiveSetter: (val) -> updateQualityCurrentProduct(val)
  reactiveValue: -> Session.get('currentImport')?.currentQuality ? 0
  reactiveMax: -> 9999
  reactiveMin: -> 0
  reactiveStep: -> 1