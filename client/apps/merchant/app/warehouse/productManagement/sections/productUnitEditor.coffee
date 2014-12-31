lemon.defineHyper Template.productManagementUnitEditor,
  basicDetailModeEnabled: -> Session.get('productManagementCurrentProduct')?.basicDetailModeEnabled
  showChangeSmallerUnit: ->
    if @unit?.length > 0 and @conversionQuality > 1 and @productCode?.length is 11 and @allowDelete is true then true else false

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

      if @allowDelete
        conversionQuality = Math.abs(Number(template.ui.$conversionQuality.inputmask('unmaskedvalue')))
        conversionQuality = 1 if conversionQuality < 1

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

    "click .changeSmallerUnit": (event, template) ->
      if @allowDelete and Session.get('productManagementCurrentProduct')
        Meteor.call 'changedSmallerUnit', Session.get('productManagementCurrentProduct')._id, @_id, (error, result) ->
          if error then console.log error
          else
            template.ui.$importPrice.val Session.get('productManagementCurrentProduct').importPrice
            template.ui.$price.val Session.get('productManagementCurrentProduct').price



