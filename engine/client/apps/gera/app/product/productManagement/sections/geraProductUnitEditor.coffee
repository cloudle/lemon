scope = logics.geraProductManagement
lemon.defineHyper Template.geraProductManagementUnitEditor,
  rendered: ->
#    @ui.$price.inputmask "numeric",
#      {autoGroup: true, groupSeparator:",", suffix: " VNĐ", radixPoint: ".", integerDigits:11}
#    @ui.$price.val Session.get("geraProductManagementUnitEditingRow").price
#
#    @ui.$importPrice.inputmask "numeric",
#      {autoGroup: true, groupSeparator:",", suffix: " VNĐ", radixPoint: ".", integerDigits:11}
#    @ui.$importPrice.val Session.get("geraProductManagementUnitEditingRow").importPrice

    @ui.$conversionQuality.inputmask "numeric",
      {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$conversionQuality.val Session.get("geraProductManagementUnitEditingRow").conversionQuality

    @ui.$unit.select()

  events:
    "keyup input[name]": (event, template) ->
      #TODO: Kiem tra trung ten & unit!
      buildInProductUnit = @
      if event.which is 13
        scope.updateGeraProductUnit(buildInProductUnit, template)
        Session.set("geraProductManagementUnitEditingRow")
        Session.set("geraProductManagementUnitEditingRowId")
      else
        Helpers.deferredAction ->
          scope.updateGeraProductUnit(buildInProductUnit, template)
        , "geraProductManagementUpdateProductUnit"
