calculateTotalPrice = -> logics.sales.currentOrder?.currentPrice * logics.sales.currentOrder?.currentQuality
calculatePercentDiscount = -> Math.round(logics.sales.currentOrder?.currentDiscount*100/(logics.sales.currentOrder?.currentPrice * logics.sales.currentOrder?.currentQuality))

#runInitTracker = (context) ->
#  return if Sky.global.saleTracker
#  Sky.global.saleTracker = Tracker.autorun ->
#    if Session.get('currentMerchant')
#      Session.set "availableStaffSale", Meteor.users.find({}).fetch()
#      if Session.get('currentMerchant').parent
#        merchant = Session.get('currentMerchant').parent
#      else
#        merchant = Session.get('currentMerchant')._id
#      Session.set "availableCustomerSale", Schema.customers.find({parentMerchant: merchant}).fetch()
#
#    if logics.sales.templateInstance
#      if logics.sales.currentOrder?.paymentsDelivery == 0 || logics.sales.currentOrder?.paymentsDelivery == 2
#        logics.sales.templateInstance.ui.extras.toggleExtra 'delivery', false
#      else
#        logics.sales.templateInstance.ui.extras.toggleExtra 'delivery'

lemon.defineApp Template.sales,
  allowAllOrderDetail: -> if !logics.sales.currentProduct then 'disabled'
  allowSuccessOrder: -> if logics.sales.currentOrderDetails?.count() < 1 then 'disabled'

  created: ->
    Session.setDefault('allowAllOrderDetail', false)
    Session.setDefault('allowSuccessOrder', false)

  rendered: ->
    logics.sales.templateInstance = @
#    @ui.$deliveryDate.datepicker
#      language: "vi"

  events:
    "change [name='advancedMode']": (event, template) ->
      logics.sales.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    'blur .contactName': (event, template)->
      logics.sales.updateDeliveryContactName(template.find(".contactName").value)

    'blur .contactPhone': (event, template)->
      logics.sales.updateDeliveryContactPhone(template.find(".contactPhone").value)

    'blur .deliveryAddress': (event, template)->
      logics.sales.updateDeliveryAddress(template.find(".deliveryAddress").value)

    'blur .comment': (event, template)->
      logics.sales.updateDeliveryComment(template.find(".comment").value)

    'click .addOrderDetail': ()->
      logics.sales.addOrderDetail(
        logics.sales.currentOrder.currentProduct,
        logics.sales.currentOrder.currentQuality,
        logics.sales.currentOrder.currentPrice,
        logics.sales.currentOrder.currentDiscountCash
      )

    'click .finish': (event, template)->
#      if Sky.global.currentOrder.data.paymentsDelivery is 1
#        expire = template.ui.$deliveryDate.data('datepicker').dates[0]
#        Sky.global.currentOrder.updateDeliveryDate(expire)

      logics.sales.finishOrder(logics.sales.currentOrder._id)
#      Meteor.call "finishOrder", logics.sales.currentOrder._id, (error, result) -> console.log error.error if error
