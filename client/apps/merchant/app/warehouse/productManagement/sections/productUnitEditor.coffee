lemon.defineHyper Template.productManagementUnitEditor,
  basicDetailModeEnabled: -> Session.get('productManagementCurrentProduct')?.basicDetailModeEnabled

  rendered: ->
    @ui.$price.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", suffix: " VNĐ", radixPoint: ".", integerDigits:11}
    @ui.$price.val Session.get("productManagementUnitEditingRow").price

    @ui.$importPrice.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", suffix: " VNĐ", radixPoint: ".", integerDigits:11}
    @ui.$importPrice.val Session.get("productManagementUnitEditingRow").importPrice

    @ui.$conversionQuality.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$conversionQuality.val Session.get("productManagementUnitEditingRow").conversionQuality

    @ui.$unit.select()

  events:
    "keyup input[name]": (event, template) ->
      #TODO: Kiem tra trung ten & unit!
      unit        = template.ui.$unit.val()
      barcode     = template.ui.$barcode.val()
      price       = Number(template.ui.$price.inputmask('unmaskedvalue'))
      importPrice = Number(template.ui.$importPrice.inputmask('unmaskedvalue'))
      price = 0 if price < 0
      importPrice = 0 if importPrice < 0

      conversionQuality = Number(template.ui.$conversionQuality.inputmask('unmaskedvalue'))
      conversionQuality = 1 if conversionQuality < 0

      unitOption =
        unit        : unit
        productCode : barcode
        price       : price
        importPrice : importPrice
      unitOption.conversionQuality = conversionQuality if conversionQuality
      Schema.productUnits.update @_id, $set: unitOption

      if event.which is 13
        Session.set("productManagementUnitEditingRow")
        Session.set("productManagementUnitEditingRowId")



