lemon.defineHyper Template.productManagementDetailEditor,
  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
  rendered: ->
    @ui.$expireDate.inputmask("dd/mm/yyyy")
    @ui.$unitQuality.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$unitQuality.val Session.get("productManagementDetailEditingRow").unitQuality
    if expireDate = Session.get("productManagementDetailEditingRow").expire
      @ui.$expireDate.val moment(expireDate).format('DDMMYYY')

    @ui.$unitQuality.select()

  events:
    "keyup input[name]": (event, template) ->
      #TODO: Kiem tra trung ten & unit!

      $paidDate = $("[name='expireDate']").inputmask('unmaskedvalue')
      isValidDate = $paidDate.length is 8 and moment($paidDate, 'DD/MM/YYYY').isValid()
      if isValidDate then expireDate = moment($paidDate, 'DDMMYYYY')._d

      unitQuality = Number(template.ui.$unitQuality.inputmask('unmaskedvalue'))
      unitQuality = 1 if unitQuality < 0

      detailOption =
        unitQuality       : unitQuality
        importQuality     : unitQuality * @conversionQuality
        availableQuality  : unitQuality * @conversionQuality
        inStockQuality    : unitQuality * @conversionQuality
      detailOption.expire = expireDate if expireDate
      Schema.productDetails.update @_id, $set: detailOption

      Schema.products.update @product, $inc:{
        totalQuality    : unitQuality * @conversionQuality - @importQuality
        availableQuality: unitQuality * @conversionQuality - @importQuality
        inStockQuality  : unitQuality * @conversionQuality - @importQuality
      }

      metroSummary = Schema.metroSummaries.findOne({merchant: Session.get('myProfile').currentMerchant})
      Schema.metroSummaries.update metroSummary._id, $inc:{
        productCount: unitQuality * @conversionQuality - @importQuality
        stockProductCount: unitQuality * @conversionQuality - @importQuality
        availableProductCount: unitQuality * @conversionQuality - @importQuality
      }

    "keypress input[name]": (event, template)->
      if event.which is 13
        Session.set("productManagementUnitEditingRow")
        Session.set("productManagementUnitEditingRowId")

