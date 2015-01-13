#scope = logics.productManagement
#lemon.defineHyper Template.productManagementUnitEditor,
#  basicDetailModeEnabled: -> Session.get('productManagementCurrentProduct')?.basicDetailModeEnabled
#  showChangeSmallerUnit: ->
#    if @unit?.length > 0 and @conversionQuality > 1 and @productCode?.length is 11 and @allowDelete is true then true else false
#
#  rendered: ->
#    @ui.$price.inputmask "numeric",
#      {autoGroup: true, groupSeparator:",", suffix: " VNĐ", radixPoint: ".", integerDigits:11}
#    @ui.$price.val Session.get("productManagementUnitEditingRow").price
#
#    @ui.$importPrice.inputmask "numeric",
#      {autoGroup: true, groupSeparator:",", suffix: " VNĐ", radixPoint: ".", integerDigits:11}
#    @ui.$importPrice.val Session.get("productManagementUnitEditingRow").importPrice
#
#    @ui.$conversionQuality.inputmask "numeric",
#      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
#    @ui.$conversionQuality.val Session.get("productManagementUnitEditingRow").conversionQuality
#
#    @ui.$unit.select()
#
#  events:
#    "keyup input[name]": (event, template) ->
#      #TODO: Kiem tra trung ten & unit!
#      productUnit = @
#      if event.which is 13
#        scope.updateProductUnit(productUnit, template)
#        Session.set("productManagementUnitEditingRow")
#        Session.set("productManagementUnitEditingRowId")
#      else
#        Helpers.deferredAction ->
#          scope.updateProductUnit(productUnit, template)
#        , "productManagementUpdateProductUnit"
#
#    "click .changeSmallerUnit": (event, template) ->
#      if @allowDelete and Session.get('productManagementCurrentProduct')
#        Meteor.call 'changedSmallerUnit', Session.get('productManagementCurrentProduct')._id, @_id, (error, result) ->
#          if error then console.log error
#          else
#            template.ui.$importPrice.val result.importPrice
#            template.ui.$price.val result.price
#
#
#
