logics.imports.qualityOptions = ->
  reactiveSetter: (val) -> Schema.imports.update(Session.get('currentImport')._id, {$set: { currentQuality: val }})
  reactiveValue: -> Session.get('currentImport')?.currentQuality ? 0
  reactiveMax: -> 9999
  reactiveMin: -> 0
  reactiveStep: -> 1