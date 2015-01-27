scope = logics.distributorReturn
setTime = -> Session.set('realtime-now', new Date())

lemon.defineHyper Template.distributorReturnDetailSection,
  merchant: -> Schema.merchants.findOne(Session.get('myProfile')?.currentMerchant)
  editingMode: -> Session.get("distributorReturnEditingRow")?._id is @_id
  editingData: -> Session.get("distributorReturnEditingRow")
  returnComment: -> Session.get("currentDistributorReturnComment") ? Session.get("currentDistributorReturn")?.comment

  crossReturnAvailableQuality: ->
    if currentDistributorReturn = Session.get('currentDistributorReturn')
      returnDetail   = @
      currentProduct = Schema.productDetails.find({distributor: currentDistributorReturn.distributor, product: returnDetail.product}).fetch()
      sameProducts = Schema.returnDetails.find({return: returnDetail.return, product: returnDetail.product}).fetch()
      crossProductQuality = 0
      currentProductQuality = 0
      crossProductQuality += item.returnQuality for item in sameProducts
      currentProductQuality += item.availableQuality for item in currentProduct

      crossAvailable = currentProductQuality - crossProductQuality
      if crossAvailable < 0
        crossAvailable = Math.ceil(Math.abs(crossAvailable/returnDetail.conversionQuality))*(-1)
      else
        Math.ceil(Math.abs(crossAvailable/returnDetail.conversionQuality))

      return {
        crossAvailable: crossAvailable
        isValid: crossAvailable > 0
        invalid: crossAvailable < 0
        errorClass: if crossAvailable >= 0 then '' else 'errors'
      }

  returnDetails: -> Schema.returnDetails.find({return: @_id}).fetch()
  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: ->
    Meteor.clearInterval(@timeInterval)
    Session.set("currentDistributorReturnComment")

  events:
    "click .detail-row": ->
      Session.set("distributorReturnEditingRowId", @_id)

    "input [name='returnComment']": (event, template) ->
      Helpers.deferredAction ->
        if Session.get('currentDistributorReturn')
          comment = template.ui.$returnComment.val()
          Session.set("currentDistributorReturnComment", comment)
          Schema.returns.update Session.get("currentDistributorReturn")._id, $set:{comment: comment}
      , "distributorReturnUpdateComment", 1000

    "click .deleteReturnDetail": (event, template) ->
      returnDetail = @
      Schema.returnDetails.remove returnDetail._id
      scope.reCalculateReturn(returnDetail.return)
