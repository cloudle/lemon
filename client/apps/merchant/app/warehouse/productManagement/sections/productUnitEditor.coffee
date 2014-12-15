lemon.defineHyper Template.productManagementUnitEditor,
  basicDetailModeEnabled: -> Session.get('productManagementCurrentProduct')?.basicDetailModeEnabled
  rendered: ->
    @ui.$price.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", suffix: " VNĐ", radixPoint: ".", integerDigits:11}
    @ui.$conversionQuality.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}

    @ui.$price.val Session.get("productManagementUnitEditingRow").price
    @ui.$conversionQuality.val Session.get("productManagementUnitEditingRow").conversionQuality

    @ui.$unit.select()
  events:
    "keyup input[name]": (event, template) ->
      #TODO: Kiem tra trung ten & unit!
      unit = template.ui.$unit.val()
      barcode = template.ui.$barcode.val()
      price = Number(template.ui.$price.inputmask('unmaskedvalue'))
      conversionQuality = Number(template.ui.$conversionQuality.inputmask('unmaskedvalue'))

      price = 0 if price < 0
      conversionQuality = 1 if conversionQuality < 0
      Schema.productUnits.update @_id,
        $set:
          unit    : unit
          barcode : barcode
          price   : price
          conversionQuality: conversionQuality

    "keypress input[name]": (event, template)->
      if event.which is 13
        Session.set("productManagementUnitEditingRow")
        Session.set("productManagementUnitEditingRowId")

