Apps.Merchant.salesInit.push (scope) ->
  scope.handleGlobalBarcodeInput = (e) ->
    if e.keyCode is 13
      globalBarcodeInput = Session.get("globalBarcodeInput")
      globalBarcodeInput = globalBarcodeInput.substr(0, globalBarcodeInput.length - 1)
      for i in [0..globalBarcodeInput.length]
        currentBarcode = globalBarcodeInput.substr(i - globalBarcodeInput.length)
        currentProduct = Schema.products.findOne({productCode: currentBarcode})
        console.log globalBarcodeInput, currentBarcode, currentProduct
        if currentProduct
          logics.sales.addOrderDetail(currentProduct._id)
          break
        break if currentBarcode.length < 7

      Session.set('globalBarcodeInput', '')
      return

    Session.set('globalBarcodeInput', Session.get('globalBarcodeInput') + String.fromCharCode(e.keyCode))
    if Session.get('globalBarcodeInput').length > 20
      Session.set('globalBarcodeInput', Session.get('globalBarcodeInput').substr(1))

