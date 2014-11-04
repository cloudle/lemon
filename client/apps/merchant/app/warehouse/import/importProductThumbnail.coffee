lemon.defineWidget Template.importProductThumbnail,
  expire: -> if @expire then @expire.toDateString()
  events:
    "dblclick .full-desc.trash": ->
      Schema.importDetails.remove(@_id)
      logics.import.reCalculateImport(@import)