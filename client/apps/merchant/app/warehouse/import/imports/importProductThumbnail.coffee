lemon.defineWidget Template.importProductThumbnail,
  expire: -> if @expire then moment(@expire).format("DD/MM/YYYY")
  events:
    "dblclick .full-desc.trash": ->
      Schema.importDetails.remove(@_id)
      logics.import.reCalculateImport(@import)