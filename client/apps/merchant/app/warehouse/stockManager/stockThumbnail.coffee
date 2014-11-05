lemon.defineWidget Template.stockThumbnail,
  canDelete: -> @totalQuality == 0
  events:
    "dblclick .full-desc.trash": ->
      deletingProduct = Schema.products.findOne(@_id)
      Schema.products.remove(@_id) if deletingProduct?.totalQuality == 0