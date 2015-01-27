setTime = -> Session.set('realtime-now', new Date())
scope = logics.import

lemon.defineHyper Template.importDetailSection,
  merchant: -> Schema.merchants.findOne(Session.get('myProfile')?.currentMerchant)
  editingMode: -> Session.get("importEditingRow")?._id is @_id
  editingData: -> Session.get("importEditingRow")
  showProductionDate: -> if @productionDate then true else false
  showExpireDate: -> if @expire then true else false
  showDelete: -> !Session.get("currentImport")?.submitted
  importDescription: -> Session.get("currentImportDescription") ? @import?.description
  distributorOldDebt: ->
    distributor = Schema.distributors.findOne(Session.get("currentImport")?.distributor)
    if distributor then distributor.importDebt + distributor.customImportDebt else 0

  distributorFinalDebt: ->
    distributor = Schema.distributors.findOne(Session.get("currentImport")?.distributor)
    if distributor and @import
      distributor.importDebt + distributor.customImportDebt + @import.totalPrice - @import.deposit
    else 0

  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: ->
    Meteor.clearInterval(@timeInterval)
    Session.set("currentImportDescription")

  events:
    "click .detail-row": ->
      if Session.get("currentImport")?.submitted is false
        Session.set("importEditingRowId", @_id)

    "click .deleteImportDetail": (event, template) ->
      Schema.importDetails.remove @_id
      scope.reCalculateImport(@import)
#      Schema.imports.update @import, $inc:{totalPrice: -@totalPrice, deposit: -@totalPrice, debit: 0}

    "keyup [name='importDescription']": (event, template)->
      Helpers.deferredAction ->
        if currentImport = Session.get('currentImport')
          description = template.ui.$importDescription.val()
          Session.set("currentImportDescription", description)
          Schema.imports.update currentImport._id, $set:{description: description}
      , "currentImportUpdateDescription", 1000


