scope = logics.agencyProductManagement
lemon.defineHyper Template.agencyProductManagementDetailEditor,
  totalPrice: -> @unitPrice*@unitQuality

  rendered: ->
    @ui.$expireDate.inputmask("dd/mm/yyyy")
    if expireDate = Session.get(scope.agencyProductManagementDetailEditingRow).expire
      @ui.$expireDate.val moment(expireDate).format('DDMMYYY')

    @ui.$unitQuality.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$unitQuality.val Session.get(scope.agencyProductManagementDetailEditingRow).unitQuality

    @ui.$importPrice.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$importPrice.val Session.get(scope.agencyProductManagementDetailEditingRow).unitPrice


    @ui.$unitQuality.select()

  events:
    "keyup input[name]": (event, template) ->
      #TODO: Kiem tra trung ten & unit!
      if Session.get(scope.agencyProductManagementBranchProduct)?.basicDetailModeEnabled
        productDetail = @
        if event.which is 13
          scope.updateBasicProductDetail(productDetail._id, template)
          Session.set(scope.agencyProductManagementDetailEditingRow)
          Session.set(scope.agencyProductManagementDetailEditingRowId)
        else
          Helpers.deferredAction ->
            scope.updateBasicProductDetail(productDetail._id, template)
          , "agencyProductManagementUpdateBasicProductDetail"
