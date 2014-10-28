formatPaymentMethodSearch = (item) -> "#{item.name}" if item
#--------------Helper-------------------------------------------->
calculateCurrentOrderPercentDiscount= (currentOrder)->
  if currentOrder.discountCash is 0 then 0
  else Math.round(currentOrder.discountCash/currentOrder.totalPrice*100)

loadDeliverDetail = (currentOrder)->
  if currentOrder.paymentsDelivery is 1
    {
    contactName     : currentOrder.contactName
    contactPhone    : currentOrder.contactPhone
    deliveryAddress : currentOrder.deliveryAddress
    deliveryDate    : currentOrder.deliveryDate
    comment         : currentOrder.comment
    }
  else {}

calculateCurrentDebit = (currentOrder)->
  switch currentOrder.paymentMethod
    when 0 then currentOrder.currentDeposit - currentOrder.finalPrice
    when 1 then 0

calculateCurrentFinalPrice = (currentOrder)->
  totalPrice = logics.sales.currentOrder?.currentPrice * logics.sales.currentOrder?.currentQuality
  totalPrice - logics.sales.currentOrder?.currentDiscountCash

#---------------Tracker Autorun------------------------------>
calculateTotalPrice = -> logics.sales.currentOrder?.currentPrice * logics.sales.currentOrder?.currentQuality
calculatePercentDiscount = -> Math.round(logics.sales.currentOrder?.currentDiscount*100/(logics.sales.currentOrder?.currentPrice * logics.sales.currentOrder?.currentQuality))

maxQuality = ->
  qualityProduct = Session.get('currentProductInstance')?.availableQuality if Session.get('currentProductInstance')
  qualityOrderDetail = _.findWhere(Session.get('currentOrderDetails'), {product: logics.sales.currentOrder.currentProduct})?.quality ? 0
  max = qualityProduct - qualityOrderDetail
  max

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
#    if Session.get('currentWarehouse') and Session.get('currentProfile')?.currentOrder
#      orderHistory =  Schema.orders.find({
#        merchant: Session.get('currentMerchant')._id
#        warehouse: Session.get('currentWarehouse')._id
#        creator: Meteor.userId()
#      }).fetch()
#      Session.set 'orderHistory', orderHistory
#      if orderHistory.length > 0
#        order = _.findWhere(orderHistory, {_id: Session.get('currentProfile').currentOrder})
#        if order
#          Sky.global.currentOrder = Order.findOne(order._id)
#          Session.set 'currentOrder', Sky.global.currentOrder.data
#        else
#          Sky.global.currentOrder = Order.findOne(orderHistory[0]._id)
#          Session.set 'currentOrder', Sky.global.currentOrder.data
#      else
##        Order.createOrderAndSelect()
#
#    if logics.sales.currentOrder
#      Session.set 'currentOrderDetails', Schema.orderDetails.find({order: logics.sales.currentOrder._id}).fetch()
#      Session.set 'currentProductInstance', Schema.products.findOne(logics.sales.currentOrder.currentProduct)
#
#      Session.set 'currentProductMaxTotalPrice', calculateTotalPrice()
#      Session.set 'currentProductMaxQuality', maxQuality()
#      Session.set 'currentProductDiscountPercent', calculatePercentDiscount()
#
#    if logics.sales.currentOrder?.buyer and Session.get('currentMerchant')?.parentMerchant
#      buyer = Schema.customers.findOne({
#        _id: logics.sales.currentOrder.buyer
#        parentMerchant: Session.get('currentMerchant').parentMerchant
#      })
#      (Session.set 'currentCustomerSale', buyer) if buyer
#
#    if logics.sales.currentOrder?.currentProduct
#      if Schema.products.findOne({_id: logics.sales.currentOrder.currentProduct, warehouse: logics.sales.currentOrder.warehouse})
#        Session.set('allowAllOrderDetail', true) unless Session.get('allowAllOrderDetail')
#      else
#        Session.set('allowAllOrderDetail', false) if Session.get('allowAllOrderDetail')
#
#    if Session.get('currentOrderDetails')?.length > 0
#      Session.set('allowSuccessOrder', true) unless Session.get('allowSuccessOrder')
#    else
#      Session.set('allowSuccessOrder', false) if Session.get('allowSuccessOrder')
#
#
#    if logics.sales.templateInstance
#      if logics.sales.currentOrder?.paymentsDelivery == 0 || logics.sales.currentOrder?.paymentsDelivery == 2
#        logics.sales.templateInstance.ui.extras.toggleExtra 'delivery', false
#      else
#        logics.sales.templateInstance.ui.extras.toggleExtra 'delivery'

lemon.defineApp Template.sales,
  deliveryDetail: -> loadDeliverDetail(logics.sales.currentOrder) if logics.sales.currentOrder
  currentFinalPrice: -> calculateCurrentFinalPrice(logics.sales.currentOrder) if logics.sales.currentOrder
  currentDebit: ->  calculateCurrentDebit(logics.sales.currentOrder) if logics.sales.currentOrder

#  currentOrderPercentDiscount: -> calculateCurrentOrderPercentDiscount(logics.sales.currentOrder) if logics.sales.currentOrder
  allowAllOrderDetail: -> unless Session.get('allowAllOrderDetail') then 'disabled'
  allowSuccessOrder: -> unless Session.get('allowSuccessOrder') then 'disabled'

  created: ->
    Session.setDefault('allowAllOrderDetail', false)
    Session.setDefault('allowSuccessOrder', false)

  rendered: ->
    logics.sales.templateInstance = @
#    @ui.$deliveryDate.datepicker
#      language: "vi"

  events:
#    "change [name='advancedMode']": (event, template) ->
#      logics.sales.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

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
        logics.sales.currentOrder.currentProduct
        logics.sales.currentOrder.currentQuality
        logics.sales.currentOrder.currentPrice
        logics.sales.currentOrder.currentDiscountCash
      )

    'click .finish': (event, template)->
#      if Sky.global.currentOrder.data.paymentsDelivery is 1
#        expire = template.ui.$deliveryDate.data('datepicker').dates[0]
#        Sky.global.currentOrder.updateDeliveryDate(expire)

      logics.sales.finishOrder(logics.sales.currentOrder._id)


#  tabOptions                    : logics.sales.tabOptions()
#  saleDetailOptions             : logics.sales.saleDetailOptions()
#
#  warehouseSelectOptions        : logics.sales.warehouseSelectOptions()
#
#  currentProductSelectOptions   : logics.sales.productSelectOptions()
#  currentProductQualityOptions  : logics.sales.qualityOptions()
#  currentProductPriceOptions    : logics.sales.priceOptions()
#  currentProductDiscountCashOptions    : logics.sales.discountCashOptions()
#  currentProductDiscountPercentOptions : logics.sales.discountPercentOptions()
#
#
#  customerSelectOptions         : logics.sales.customerSelectOptions()
#  sellerSelectOptions           : logics.sales.sellerSelectOptions()
#  paymentMethodSelectOptions    : logics.sales.paymentMethodSelectOptions()
#  paymentsDeliverySelectOptions : logics.sales.paymentsDeliverySelectOptions()
#  billDiscountSelectOptions     : logics.sales.billDiscountSelectOptions()
#  depositOptions                : logics.sales.depositOptions()
#
#
#  billCashDiscountOptions       : logics.sales.billCashDiscountOptions()
#  billPercentDiscountOptions    : logics.sales.billPercentDiscountOptions()


  currentProductSelectOptions:
    query: (query) -> query.callback
      results: [{_id: 1, name: 'sang'}, {_id: 2, name: 'loc'}, {_id: 3, name: 'ky'}]
      text: 'id'
    initSelection: (element, callback) -> callback {_id: 1, name: 'sang'}
    formatSelection: formatPaymentMethodSearch
    formatResult: formatPaymentMethodSearch
    placeholder: 'CHỌN SẢN PTGD'
    minimumResultsForSearch: -1
    changeAction: (e) ->
    reactiveValueGetter: -> {_id: 1, name: 'sang'}

  currentProductQualityOptions:
    reactiveSetter: (val) ->
    reactiveValue: -> 1
    reactiveMax: -> 10
    reactiveMin: -> 0
    reactiveStep: -> 1

