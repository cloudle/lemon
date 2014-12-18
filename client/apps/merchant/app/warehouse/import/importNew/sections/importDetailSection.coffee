setTime = -> Session.set('realtime-now', new Date())
scope = logics.import

lemon.defineHyper Template.importDetailSection,
  merchant: -> Schema.merchants.findOne(Session.get('myProfile')?.currentMerchant)
  editingMode: -> Session.get("importEditingRow")?._id is @_id
  editingData: -> Session.get("importEditingRow")
  product: -> Schema.products.findOne(@product)
  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
  showProductionDate: -> if @productionDate then true else false
  showExpireDate: -> if @expire then true else false
  showDelete: -> !Session.get("currentImport")?.submitted

  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: -> Meteor.clearInterval(@timeInterval)
  events:
    "click .detail-row": ->
      if Session.get("currentImport")?.submitted is false
        Session.set("importEditingRowId", @_id)

    "click .deleteImportDetail": (event, template) ->
      Schema.importDetails.remove @_id
      scope.reCalculateImport(@import)
#      Schema.imports.update @import, $inc:{totalPrice: -@totalPrice, deposit: -@totalPrice, debit: 0}

    "keyup [name='importDescription']": (event, template)->
      if currentImport = Session.get('currentImport')
        description = template.find("[name='importDescription']")
        Schema.imports.update currentImport._id, $set:{description: description.value}
