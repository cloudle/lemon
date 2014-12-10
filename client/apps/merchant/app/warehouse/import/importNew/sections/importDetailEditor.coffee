lemon.defineHyper Template.importDetailEditor,
  product: -> Schema.products.findOne(@product)
  showDelete: -> !Session.get("currentImport")?.submitted

  rendered: ->
    @ui.$editProductionDate.inputmask("dd/mm/yyyy")
    @ui.$editExpireDate.inputmask("dd/mm/yyyy")
    @ui.$editImportQuality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$editImportPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}

    @ui.$editImportQuality.val Session.get("importEditingRow").importQuality
    @ui.$editImportPrice.val Session.get("importEditingRow").importPrice
    @ui.$editProductionDate.val if Session.get("importEditingRow").productionDate then moment(Session.get("importEditingRow").productionDate).format('DDMMYYYY')
    @ui.$editExpireDate.val if Session.get("importEditingRow").expire then moment(Session.get("importEditingRow").expire).format('DDMMYYYY')

    @ui.$editImportQuality.select()

  events:
    "keyup input[name]": (event, template) ->
      if event.which is 8 || event.which is 46 || 47 < event.which < 58 || 95 < event.which < 106
        importQuality   = Number(template.ui.$editImportQuality.inputmask('unmaskedvalue'))
        importPrice     = Number(template.ui.$editImportPrice.inputmask('unmaskedvalue'))

        $productionDate = template.ui.$editProductionDate.inputmask('unmaskedvalue')
        isValidDate     = $productionDate.length is 8 and moment($productionDate, 'DD/MM/YYYY').isValid()
        if isValidDate then productionDate = moment($productionDate, 'DD/MM/YYYY')._d else productionDate = undefined

        $expireDate = template.ui.$editExpireDate.inputmask('unmaskedvalue')
        isValidDate = $expireDate.length is 8 and moment($expireDate, 'DD/MM/YYYY').isValid()
        if isValidDate then expireDate = moment($expireDate, 'DD/MM/YYYY')._d else expireDate = undefined

        totalPrice = importQuality * importPrice

        setOption =
          importQuality: importQuality
          importPrice: importPrice
          totalPrice: totalPrice
        setOption.productionDate = productionDate if productionDate
        setOption.expire = expireDate if expireDate

        changPrice = totalPrice - Schema.importDetails.findOne(@_id).totalPrice

        Schema.importDetails.update @_id, $set: setOption
        Schema.imports.update @import, $inc:{totalPrice: changPrice, deposit: changPrice, debit: 0}

    "click .deleteOrderDetail": (event, template) ->
      Schema.importDetails.remove @_id
      Schema.imports.update @import, $inc:{totalPrice: -@totalPrice, deposit: -@totalPrice, debit: 0}
