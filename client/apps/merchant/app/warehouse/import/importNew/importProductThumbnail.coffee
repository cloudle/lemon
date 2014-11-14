lemon.defineWidget Template.importProductThumbnail,
  expire: -> if @expire then moment(@expire).fromNow()
  events:
    "dblclick .full-desc.trash": ->
      Schema.importDetails.remove(@_id)
      logics.import.reCalculateImport(@import)