scope = logics.customerReturn
setTime = -> Session.set('realtime-now', new Date())

lemon.defineHyper Template.customerReturnDetailSection,
  returnDetails: -> Schema.returnDetails.find({return: @_id}).fetch()

  merchant: -> Schema.merchants.findOne(Session.get('myProfile')?.currentMerchant)
  editingMode: -> Session.get("customerReturnEditingRow")?._id is @_id
  editingData: -> Session.get("customerReturnEditingRow")
  productName: -> Schema.products.findOne(@product)?.name
  returnComment: -> Session.get("currentCustomerReturnComment") ? Session.get("currentCustomerReturn")?.comment

  crossReturnAvailableQuality: ->
    if currentCustomerReturn = Session.get('currentCustomerReturn')
      returnDetail = @
      currentProduct = []
      Schema.sales.find({buyer: currentCustomerReturn.customer}).forEach(
        (sale)->
          Schema.saleDetails.find({sale: sale._id, product: returnDetail.product}).forEach(
            (saleDetail)-> currentProduct.push saleDetail
          )
      )
      sameProducts = Schema.returnDetails.find({return: returnDetail.return, product: returnDetail.product}).fetch()

      crossProductQuality = 0
      currentProductQuality = 0
      crossProductQuality += item.returnQuality for item in sameProducts
      currentProductQuality += (item.quality - item.returnQuality) for item in currentProduct

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

  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: ->
    Meteor.clearInterval(@timeInterval)
    Session.set("currentCustomerReturnComment")


  events:
    "click .detail-row": -> Session.set("customerReturnEditingRowId", @_id)
    "input [name='returnComment']": (event, template) ->
      Helpers.deferredAction ->
        if Session.get('currentCustomerReturn')
          comment = template.ui.$returnComment.val()
          Session.set("currentCustomerReturnComment", comment)
          Schema.returns.update Session.get("currentCustomerReturn")._id, $set:{comment: comment}
      , "customerReturnUpdateComment", 1000

    "click .deleteReturnDetail": (event, template) ->
      returnDetail = @
      Schema.returnDetails.remove returnDetail._id
      scope.reCalculateReturn(returnDetail.return)



