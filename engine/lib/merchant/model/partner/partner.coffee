Schema.add 'partners', "Partner", class Partner
  @findBy: (importId, warehouseId = null, merchantId = null)->
