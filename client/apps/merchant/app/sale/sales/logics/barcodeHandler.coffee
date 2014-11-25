Apps.Merchant.salesInit.push (scope) ->
  scope.handleGlobalBarcodeInput = (e) ->
    if e.keyCode is 13
      for i in [0..Session.get('globalBarcodeInput').length]
        currentBarcode = Session.get('globalBarcodeInput').substr(i - Session.get('globalBarcodeInput').length)
        currentProduct = Schema.products.findOne({productCode: currentBarcode})
        #console.log currentBarcode, currentProduct
        if currentProduct
          logics.sales.addOrderDetail(currentProduct._id)
          break
        break if currentBarcode.length < 7

      Session.set('globalBarcodeInput', '')
      return
    Session.set('globalBarcodeInput', Session.get('globalBarcodeInput') + String.fromCharCode(e.keyCode))
    if Session.get('globalBarcodeInput').length > 20
      Session.set('globalBarcodeInput', Session.get('globalBarcodeInput').substr(1))

