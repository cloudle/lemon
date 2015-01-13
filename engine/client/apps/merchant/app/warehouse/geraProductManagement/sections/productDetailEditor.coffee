#scope = logics.productManagement
#lemon.defineHyper Template.productManagementDetailEditor,
#  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
#  totalPrice: -> @unitPrice*@unitQuality
#
#  rendered: ->
#    @ui.$expireDate.inputmask("dd/mm/yyyy")
#    if expireDate = Session.get("productManagementDetailEditingRow").expire
#      @ui.$expireDate.val moment(expireDate).format('DDMMYYY')
#
#    @ui.$unitQuality.inputmask "numeric",
#      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
#    @ui.$unitQuality.val Session.get("productManagementDetailEditingRow").unitQuality
#
#    @ui.$importPrice.inputmask "numeric",
#      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
#    @ui.$importPrice.val Session.get("productManagementDetailEditingRow").unitPrice
#
#
#    @ui.$unitQuality.select()
#
#  events:
#    "keyup input[name]": (event, template) ->
#      #TODO: Kiem tra trung ten & unit!
#      if Session.get("productManagementCurrentProduct")?.basicDetailModeEnabled
#        productDetail = @
#        if event.which is 13
#          scope.updateBasicProductDetail(productDetail, template)
#          Session.set("productManagementDetailEditingRow")
#          Session.set("productManagementDetailEditingRowId")
#        else
#          Helpers.deferredAction ->
#            scope.updateBasicProductDetail(productDetail, template)
#          , "productManagementUpdateBasicProductDetail"
