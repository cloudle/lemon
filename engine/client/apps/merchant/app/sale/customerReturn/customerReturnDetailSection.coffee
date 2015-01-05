scope = logics.customerReturn
setTime = -> Session.set('realtime-now', new Date())

lemon.defineHyper Template.customerReturnDetailSection,
  merchant: -> Schema.merchants.findOne(Session.get('myProfile')?.currentMerchant)
  editingMode: -> Session.get("customerReturnEditingRow")?._id is @_id
  editingData: -> Session.get("customerReturnEditingRow")
  productName: -> Schema.products.findOne(@product)?.name
  unitName: -> if @unit then Schema.productUnits.findOne(@unit)?.unit else Schema.products.findOne(@product)?.basicUnit

  crossReturnAvailableQuality: ->
    if currentCustomerReturn = Session.get('currentCustomerReturn')
      returnDetail   = @
      currentProduct = []
      Schema.sales.find({buyer: currentCustomerReturn.customer}).forEach(
        (sale)->
          Schema.saleDetails.find({sale: sale._id, product: returnDetail.product}).forEach(
            (saleDetail)-> currentProduct.push saleDetail
          )
      )
      sameProducts = Schema.returnDetails.find({return: @return, product: @product}).fetch()

      crossProductQuality = 0
      currentProductQuality = 0
      crossProductQuality += item.returnQuality for item in sameProducts
      currentProductQuality += (item.quality - item.returnQuality) for item in currentProduct

      crossAvailable = currentProductQuality - crossProductQuality
      if crossAvailable < 0
        crossAvailable = Math.ceil(Math.abs(crossAvailable/@conversionQuality))*(-1)
      else
        Math.ceil(Math.abs(crossAvailable/@conversionQuality))

      return {
        crossAvailable: crossAvailable
        isValid: crossAvailable > 0
        invalid: crossAvailable < 0
        errorClass: if crossAvailable >= 0 then '' else 'errors'
      }



  returnDetails: -> Schema.returnDetails.find({return: @_id}).fetch()
  created: -> @timeInterval = Meteor.setInterval(setTime, 1000)
  destroyed: -> Meteor.clearInterval(@timeInterval)

  events:
    "click .detail-row": -> Session.set("customerReturnEditingRowId", @_id)
    "input [name='returnComment']": (event, template) ->
      comment = template.ui.$returnComment.val()
      Schema.returns.update Session.get("currentCustomerReturn")._id, $set:{comment: comment} if Session.get('currentCustomerReturn')

    "click .deleteReturnDetail": (event, template) ->
      Schema.returnDetails.remove @_id
      scope.reCalculateReturn(@return)



