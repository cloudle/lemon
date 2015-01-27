scope = logics.sales

lemon.defineHyper Template.saleDetailEditor,
#  price: ->
#    Meteor.setTimeout ->
#      $("input[name='price']").change()
#    , 100
#    @price
#
#  quality: ->
#    Meteor.setTimeout ->
#      $("input[name='quality']").change()
#    , 100
#    @quality
#
#  discountCash: ->
#    Meteor.setTimeout ->
#      $("input[name='discountCash']").change()
#    , 100
#    @discountCash

#  product: -> Schema.products.findOne(@product)
#  unitName: -> if @unit then Schema.productUnits.findOne(@unit).unit else Schema.products.findOne(@product).basicUnit
  rendered: ->
    @ui.$editQuality.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$editPrice.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}
    @ui.$editDiscountCash.inputmask "numeric",
        {autoGroup: true, groupSeparator:",", radixPoint: ".", integerDigits:11}

    @ui.$editQuality.val Session.get("salesEditingRow").unitQuality
    @ui.$editPrice.val Session.get("salesEditingRow").unitPrice
    @ui.$editDiscountCash.val Session.get("salesEditingRow").discountCash

    @ui.$editQuality.select()


  events:
    "keyup input[name]": (event, template) ->
      saleDetail = @
      if event.which is 13
        scope.updateSaleDetail(saleDetail, template)
        Session.set("salesEditingRow")
        Session.set("salesEditingRowId")
      else
        Helpers.deferredAction ->
          scope.updateSaleDetail(saleDetail, template)
        , "salesCurrentProductCalculateSaleDetail"

    "click .deleteOrderDetail": (event, template) ->
      Schema.orderDetails.remove @_id
      logics.sales.reCalculateOrder(@order)