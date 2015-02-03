scope = logics.agencyProductManagement
lemon.defineHyper Template.agencyProductManagementUnitEditor,
  basicDetailModeEnabled: -> Session.get(scope.agencyProductManagementCurrentProduct)?.basicDetailModeEnabled
  showChangeSmallerUnit: ->
    if @unit?.length > 0 and @conversionQuality > 1 and @productCode?.length is 11 and @allowDelete is true then true else false
  showEditUnit: ->
    if @buildInProductUnit or @merchant isnt @createMerchant or @merchant isnt @parentMerchant then true else false


  rendered: ->
    @ui.$price.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", suffix: " VNĐ", radixPoint: ".", integerDigits:11}
    @ui.$price.val Session.get(scope.agencyProductManagementUnitEditingRow).price

    @ui.$importPrice.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", suffix: " VNĐ", radixPoint: ".", integerDigits:11}
    @ui.$importPrice.val Session.get(scope.agencyProductManagementUnitEditingRow).importPrice

    @ui.$conversionQuality?.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$conversionQuality?.val Session.get(scope.agencyProductManagementUnitEditingRow).conversionQuality

    @ui.$price.select()

  events:
    "keyup input[name]": (event, template) ->
      #TODO: Kiem tra trung ten & unit!
      productUnit = @
      branchProductUnit = Schema.branchProductUnits.findOne({productUnit: @_id, merchant: Session.get('myProfile').currentMerchant})
      if event.which is 13
        scope.updateProductUnit(template, productUnit, branchProductUnit)
        Session.set(scope.agencyProductManagementUnitEditingRow)
        Session.set(scope.agencyProductManagementUnitEditingRowId)
      else
        Helpers.deferredAction ->
          scope.updateProductUnit(template, productUnit, branchProductUnit)
        , "agencyProductManagementUpdateProductUnit"

    "click .changeSmallerUnit": (event, template) ->
      if @allowDelete and Session.get(scope.agencyProductManagementCurrentProduct)
        Meteor.call 'changedSmallerUnit', Session.get(scope.agencyProductManagementCurrentProduct)._id, @_id, (error, result) ->
          if error then console.log error
          else
            template.ui.$importPrice.val result.importPrice
            template.ui.$price.val result.price



