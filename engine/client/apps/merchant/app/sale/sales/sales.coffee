scope = logics.sales

lemon.defineApp Template.sales,
  allowCreateOrderDetail: -> if !scope.currentProduct then 'disabled'
  allowSuccessOrder: -> if Session.get('allowSuccess') then '' else 'disabled'
  productCreationMode: -> Session.get("salesCurrentProductCreationMode")
  showProductFilterSearch: -> Session.get("salesCurrentProductSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined

  unitName: -> if @unit then @unit.unit else @product.basicUnit
  availableUnit: ->
    if @unit then (@product.availableQuality / @unit.conversionQuality) else @product.availableQuality

  productSelectionActiveClass: ->
    if order = Session.get('currentOrder')
      if @unit
        if order.currentUnit is @unit._id then 'active' else ''
      else if !order.currentUnit
        if @product._id is order.currentProduct then 'active' else ''

  created: ->
    lemon.dependencies.resolve('saleManagement')
    Session.setDefault('allowCreateOrderDetail', false)
    Session.setDefault('allowSuccessOrder', false)
    Session.setDefault('globalBarcodeInput', '')

    if mySession = Session.get('mySession')
      Session.set('currentOrder', Schema.orders.findOne(mySession.currentOrder))
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
      Helpers.deferredAction ->
        Session.set("salesCurrentProductSearchFilter", template.ui.$searchFilter.val())
      , "salesCurrentProductSearchProduct"

#    "keypress input[name='searchFilter']": (event, template)->
#      scope.createCustomer(template) if event.which is 13 and Session.get("salesCurrentProductCreationMode")
#    "click .createCustomerBtn": (event, template) -> scope.createCustomer(template)


    "click .product-selection": -> scope.updateSelectProduct(@)

    "change [name='advancedMode']": (event, template) ->
      scope.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    "change [name ='deliveryDate']": (event, template) -> scope.updateDeliveryDate()

    'input .contactName': (event, template)->
      Helpers.deferredAction ->
        scope.updateDeliveryContactName(template.find(".contactName"))
      , "salesCurrentProductSearchProduct"

    'input .contactPhone': (event, template)->
      Helpers.deferredAction ->
        scope.updateDeliveryContactPhone(template.find(".contactPhone"))
      , "salesCurrentProductSearchProduct"

    'input .deliveryAddress': (event, template)->
      Helpers.deferredAction ->
        scope.updateDeliveryAddress(template.find(".deliveryAddress"))
      , "salesCurrentProductSearchProduct"

    'input .comment': (event, template)->
      Helpers.deferredAction ->
        scope.updateDeliveryComment(template.find(".comment"))
      , "salesCurrentProductSearchProduct"

    "dblclick": ->
      Session.set("salesEditingRowId", scope.addOrderDetail @product._id, @unit?._id)

    "click .addSaleDetail": ->
      Session.set("salesEditingRowId", scope.addOrderDetail @product._id, @unit?._id)
      event.stopPropagation()

    "click .print-command": (event, template) -> window.print()
    'click .finish': (event, template)->
      Meteor.call "finishOrder", Session.get('currentOrder')._id, (error, result) ->
        if error then console.log error
        else
          saleId = result
          Meteor.call 'confirmReceiveSale', saleId, (error, result) -> if error then console.log error
          Meteor.call 'createSaleExport', saleId, (error, result) ->  if error then console.log error
          Meteor.call 'reCalculateMetroSummaryTotalReceivableCash'
#          Schema.customers.update(Session.get('currentOrder').buyer, $set: {lastSales: saleId})
