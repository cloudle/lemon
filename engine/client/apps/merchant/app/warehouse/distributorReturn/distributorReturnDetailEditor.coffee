scope = logics.distributorReturn

lemon.defineHyper Template.distributorReturnDetailEditor,
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

  rendered: ->
    @ui.$editQuality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$editPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}

    @ui.$editQuality.val Session.get("distributorReturnEditingRow")?.unitReturnQuality
    @ui.$editPrice.val Session.get("distributorReturnEditingRow")?.unitReturnsPrice

    @ui.$editQuality.select()


  events:
    "keyup input[name]": (event, template) ->
      returnDetail = @
      if event.which is 13
        scope.updateDistributorReturnDetail(returnDetail, template)
        Session.set("distributorReturnEditingRow")
        Session.set("distributorReturnEditingRowId")
      else
        Helpers.deferredAction ->
          scope.updateDistributorReturnDetail(returnDetail, template)
        , "distributorReturnUpdateReturnDetail"

    "click .deleteReturnDetail": (event, template) ->
      returnDetail = @
      Schema.returnDetails.remove returnDetail._id
      scope.reCalculateReturn(returnDetail.return)