setTime = -> Session.set('realtime-now', new Date())
scope = logics.import

lemon.defineHyper Template.importDetailSection,
  showProductionDate: -> if @productionDate then true else false
  showExpireDate: -> if @expire then true else false
  showDelete: -> !Session.get("currentImport")?.submitted
  importDescription: -> Session.get("currentImportDescription") ? @import?.description

  editingMode: -> Session.get("importEditingRow")?._id is @_id
  editingData: -> Session.get("importEditingRow")

  oldDebt: ->
    distributor = Session.get('currentImportDistributor')
    partner = Session.get('currentImportPartner')

    if @import?.distributor and distributor then distributor.importDebt + distributor.customImportDebt
    else if @import?.partner and partner then partner.importCash + partner.loanCash - partner.saleCash - partner.paidCash
    else 0

  finalDebt: ->
    distributor = Session.get('currentImportDistributor')
    partner = Session.get('currentImportPartner')

    if @import?.distributor and distributor
      distributor.importDebt + distributor.customImportDebt + @import.totalPrice - @import.deposit
    else if @import?.partner and partner
      partner.importCash + partner.loanCash - partner.saleCash - partner.paidCash + @import.totalPrice - @import.deposit
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

    "keyup [name='importDescription']": (event, template)->
      Helpers.deferredAction ->
        if currentImport = Session.get('currentImport')
          description = template.ui.$importDescription.val()
          Session.set("currentImportDescription", description)
          Schema.imports.update currentImport._id, $set:{description: description}
      , "currentImportUpdateDescription", 1000


