scope = logics.import
lemon.defineHyper Template.importDetailEditor,
  showDelete: -> !Session.get("currentImport")?.submitted

  rendered: ->
    @ui.$editExpireDate.inputmask("dd/mm/yyyy")
    @ui.$editImportQuality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11, rightAlign: false}
    @ui.$editImportPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}

    @ui.$editImportQuality.val Session.get("importEditingRow").unitQuality
    @ui.$editImportPrice.val Session.get("importEditingRow").unitPrice
    @ui.$editExpireDate.val if Session.get("importEditingRow").expire then moment(Session.get("importEditingRow").expire).format('DDMMYYYY')

    @ui.$editImportQuality.select()

  events:
    "keyup input[name]": (event, template) ->
      importDetail = @
      if event.which is 13
        scope.updateImportDetail(importDetail, template)
        Session.set("importEditingRow")
        Session.set("importEditingRowId")
      else if event.which is 8 || event.which is 46 || 47 < event.which < 58 || 95 < event.which < 106
        Helpers.deferredAction ->
          scope.updateImportDetail(importDetail, template)
        , "importManagementSearchUpdateImportDetail"

    "click .deleteOrderDetail": (event, template) ->
      Schema.importDetails.remove @_id
      scope.reCalculateImport(@import)
#      Schema.imports.update @import, $inc:{totalPrice: -@totalPrice, debit: -@totalPrice}
