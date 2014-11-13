calculateTotalPrice = -> logics.sales.currentOrder?.currentPrice * logics.sales.currentOrder?.currentQuality
calculatePercentDiscount = -> Math.round(logics.sales.currentOrder?.currentDiscount*100/(logics.sales.currentOrder?.currentPrice * logics.sales.currentOrder?.currentQuality))

lemon.defineApp Template.sales,
  allowAllOrderDetail: -> if !logics.sales.currentProduct then 'disabled'
  allowSuccessOrder: -> if Session.get('allowSuccess') then '' else 'disabled'

  created: ->
    Session.setDefault('allowAllOrderDetail', false)
    Session.setDefault('allowSuccessOrder', false)

  rendered: ->
    logics.sales.templateInstance = @
    lemon.ExcuteLogics()
    $("[name=deliveryDate]").datepicker('setDate', logics.sales.deliveryDetail?.deliveryDate)

  events:
    "change [name='advancedMode']": (event, template) ->
      logics.sales.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    "change [name ='deliveryDate']": (event, template) -> logics.sales.updateDeliveryDate()

    'blur .contactName': (event, template)->
      logics.sales.updateDeliveryContactName(template.find(".contactName"))

    'blur .contactPhone': (event, template)->
      logics.sales.updateDeliveryContactPhone(template.find(".contactPhone"))

    'blur .deliveryAddress': (event, template)->
      logics.sales.updateDeliveryAddress(template.find(".deliveryAddress"))

    'blur .comment': (event, template)->
      logics.sales.updateDeliveryComment(template.find(".comment"))

    'click .addOrderDetail': () ->
      logics.sales.addOrderDetail(
        logics.sales.currentOrder.currentProduct,
        logics.sales.currentOrder.currentQuality,
        logics.sales.currentOrder.currentPrice,
        logics.sales.currentOrder.currentDiscountCash
      )
    "click .print-preview": (event, template) -> $(template.find '#salePrinter').modal()
    'click .finish': (event, template)->
      Meteor.call "finishOrder", logics.sales.currentOrder._id, (error, result) -> console.log error.error if error
