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
  showDelete: -> !Session.get("currentImport")?.submitted

  events:
    "click .detail-row": ->
      if Session.get("currentImport")?.submitted is false
        Session.set("importEditingRowId", @_id)

    "click .deleteImportDetail": (event, template) ->
      Schema.importDetails.remove @_id
      Schema.imports.update @import, $inc:{totalPrice: -@totalPrice, deposit: -@totalPrice, debit: 0}

#    "input"
