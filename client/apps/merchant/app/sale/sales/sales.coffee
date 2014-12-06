scope = logics.sales

lemon.defineApp Template.sales,
  allowCreateOrderDetail: -> if !scope.currentProduct then 'disabled'
  allowSuccessOrder: -> if Session.get('allowSuccess') then '' else 'disabled'
  productSelectionActiveClass: -> if Session.get('currentOrder')?.currentProduct is @._id then 'active' else ''
  productCreationMode: -> Session.get("salesCurrentProductCreationMode")
  showProductFilterSearch: -> Session.get("salesCurrentProductSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined

  created: ->
    Session.setDefault('allowCreateOrderDetail', false)
    Session.setDefault('allowSuccessOrder', false)
    Session.setDefault('globalBarcodeInput', '')

    if mySession = Session.get('mySession')
      Session.set('salesCurrentOrderSelected', Schema.orders.findOne(mySession.currentOrder))
      Meteor.subscribe('orderDetails', mySession.currentOrder)

  rendered: ->
    scope.templateInstance = @
    lemon.ExcuteLogics()
    $("[name=deliveryDate]").datepicker('setDate', scope.deliveryDetail?.deliveryDate)
    $(document).on "keypress", (e) -> scope.handleGlobalBarcodeInput(e)
  destroyed: ->
    $(document).off("keypress")

  events:
    "input .search-filter": (event, template) ->
      Session.set("salesCurrentProductSearchFilter", template.ui.$searchFilter.val())
#    "keypress input[name='searchFilter']": (event, template)->
#      scope.createCustomer(template) if event.which is 13 and Session.get("salesCurrentProductCreationMode")
#    "click .createCustomerBtn": (event, template) -> scope.createCustomer(template)


    "click .product-selection": ->
      scope.updateSelectNewProduct(currentProduct) if currentProduct = Schema.products.findOne(@_id)

    "change [name='advancedMode']": (event, template) ->
      scope.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    "change [name ='deliveryDate']": (event, template) -> scope.updateDeliveryDate()

    'blur .contactName': (event, template)->
      scope.updateDeliveryContactName(template.find(".contactName"))

    'blur .contactPhone': (event, template)->
      scope.updateDeliveryContactPhone(template.find(".contactPhone"))

    'blur .deliveryAddress': (event, template)->
      scope.updateDeliveryAddress(template.find(".deliveryAddress"))

    'blur .comment': (event, template)->
      scope.updateDeliveryComment(template.find(".comment"))

    'click .addOrderDetail': () ->
      scope.addOrderDetail(
        scope.currentOrder.currentProduct,
        scope.currentOrder.currentQuality,
        scope.currentOrder.currentPrice,
        scope.currentOrder.currentDiscountCash
      )
    "click .print-preview": (event, template) -> $(template.find '#salePrinter').modal()
    'click .finish': (event, template)->
      Meteor.call "finishOrder", scope.currentOrder._id, (error, result) ->
        if error then console.log error
        else
          saleId = result
          Meteor.call 'confirmReceiveSale', saleId, (error, result) -> if error then console.log error
          Meteor.call 'createSaleExport', saleId, (error, result) ->  if error then console.log error
