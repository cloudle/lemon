lemon.defineHyper Template.importDetailEditor,
  product: -> Schema.products.findOne(@product)
  rendered: ->
    @ui.$expireDate.inputmask("dd/mm/yyyy")
    @ui.$productionDate.inputmask("dd/mm/yyyy")
    @ui.$importQuality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$importPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}

    @ui.$importQuality.select()

    @ui.$importQuality.val Session.get("importEditingRow").importQuality
    @ui.$importPrice.val Session.get("importEditingRow").importPrice
    @ui.$productionDate.val if Session.get("importEditingRow").productionDate then moment(Session.get("importEditingRow").productionDate).format('DDMMYYYY')
    @ui.$expireDate.val if Session.get("importEditingRow").expire then moment(Session.get("importEditingRow").expire).format('DDMMYYYY')

  events:
    "keyup input[name]": (event, template) ->
      importQuality   = Number(template.ui.$importQuality.inputmask('unmaskedvalue'))
      importPrice     = Number(template.ui.$importPrice.inputmask('unmaskedvalue'))

      $productionDate = template.ui.$productionDate.inputmask('unmaskedvalue')
      isValidDate     = $productionDate.length is 8 and moment($productionDate, 'DD/MM/YYYY').isValid()
      if isValidDate then productionDate = moment($productionDate, 'DD/MM/YYYY')._d else productionDate = undefined

      $expireDate = template.ui.$expireDate.inputmask('unmaskedvalue')
      isValidDate = $expireDate.length is 8 and moment($expireDate, 'DD/MM/YYYY').isValid()
      if isValidDate then expireDate = moment($expireDate, 'DD/MM/YYYY')._d else expireDate = undefined

      totalPrice = importQuality * importPrice

      setOption =
        importQuality: importQuality
        importPrice: importPrice
        totalPrice: totalPrice
      setOption.productionDate = productionDate if productionDate
      setOption.expire = expireDate if expireDate
      Schema.importDetails.update @_id, $set: setOption
      logics.import.reCalculateImport(@import)


    "click .deleteOrderDetail": (event, template) ->
      Schema.importDetails.remove @_id
      logics.import.reCalculateImport(@import)