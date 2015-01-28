scope = logics.customerReturn

lemon.defineHyper Template.customerReturnDetailEditor,
  crossReturnAvailableQuality: ->
    returnDetail = @
    if currentReturn = Session.get('currentCustomerReturn')
      currentProduct = []
      Schema.sales.find({buyer: currentReturn.customer}).forEach(
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

  rendered: ->
    @ui.$editQuality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$editPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}

    @ui.$editQuality.val Session.get("customerReturnEditingRow")?.unitReturnQuality
    @ui.$editPrice.val Session.get("customerReturnEditingRow")?.unitReturnsPrice

    @ui.$editQuality.select()


  events:
    "keyup input[name]": (event, template) ->
      returnDetail = @
      if event.which is 13
        scope.updateCustomerReturnDetail(returnDetail, template)
        Session.set("customerReturnEditingRow")
        Session.set("customerReturnEditingRowId")
      else
        Helpers.deferredAction ->
          scope.updateCustomerReturnDetail(returnDetail, template)
        , "customerReturnUpdateReturnDetail"


    "click .deleteReturnDetail": (event, template) ->
      returnDetail = @
      Schema.returnDetails.remove returnDetail._id
      scope.reCalculateReturn(returnDetail.return)