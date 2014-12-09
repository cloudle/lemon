setTime = -> Session.set('realtime-now', new Date())

lemon.defineHyper Template.importDetailSection,
  merchant: -> Schema.merchants.findOne(Session.get('myProfile')?.currentMerchant)
  editingMode: -> Session.get("importEditingRow")?._id is @_id
  editingData: -> Session.get("importEditingRow")
  product: -> Schema.products.findOne(@product)
  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: -> Meteor.clearInterval(@timeInterval)
  showProductionDate: -> if @productionDate then true else false
  showExpireDate: -> if @expire then true else false

  events:
    "click .detail-row": ->
      Session.set("importEditingRowId", @_id)

    "click .deleteImportDetail": (event, template) ->
      Schema.importDetails.remove @_id
      logics.import.reCalculateImport(@import)
