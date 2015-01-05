lemon.defineWidget Template.deliveryManagerThumbnail,
  showSelectCommand:  -> @status is 1
  showStartCommand:   -> @status is 3
  showConfirmCommand: -> @status is 4
  showFinishCommand:  -> @status is 6 or @status is 9
  showCancelCommand:  -> _.contains([2, 4, 5, 8], @status)

  showAccountingCommand:  -> @status is 5
  showExportCommand:      -> @status is 2
  showImportCommand:      -> @status is 8

  showStatus: (status) ->
    switch status
      when 1 then 'Chưa được nhận '
      when 2 then 'Chờ xác nhận kho'
      when 3 then 'Đã xác nhận xuất kho'
      when 4 then 'Đang Giao Hàng'
      when 5 then 'Giao Thành Công'
      when 6 then 'Kế Toán Đã Nhận Tiền'
      when 7 then 'Kết Thúc'
      when 8 then 'Giao Thất Bại'
      when 9 then 'Kho Đã Nhận Hàng'
      when 10 then 'Hoàn Tất'

  buttonSuccessText: (status) ->
    switch status
      when 1 then 'nhận đơn giao hàng'
      when 3 then 'xác nhận đi giao hàng'
      when 4 then 'Thành Công'
      when 5 then 'Chờ Xác Nhận Của Kế Toán'
      when 6 then 'Xác Nhận'
      when 8 then 'Chờ Xác Nhân Của Kho'
      when 9 then 'Xác Nhận'

  buttonUnSuccessText: (status) -> 'Thất Bại' if status == 4
  hideButtonSuccess: (status)-> return "display: none" if _.contains([2,5,7,8,10],status)
  hideButtonUnSuccess: (status)-> return "display: none" unless status == 4
  customerAlias: -> Schema.customers.findOne(@buyer)?.name ? @contactName
  avatarUrl: ->
    buyer = Schema.customers.findOne(@buyer)
    return undefined if !buyer
    AvatarImages.findOne(buyer.avatar)?.url()

  events:
    "click .select-command": (event, template) ->
      Meteor.call "updateDelivery", @_id, 'select', (error, result) -> console.log error if error
    "click .start-command": ->
      Meteor.call "updateDelivery", @_id, 'start', (error, result) -> console.log error if error
    "click .fail-command": ->
      Meteor.call "updateDelivery", @_id, 'fail', (error, result) -> console.log error if error
    "click .success-command": ->
      Meteor.call "updateDelivery", @_id, 'success', (error, result) -> console.log error if error
    "click .finish-command": ->
      Meteor.call "updateDelivery", @_id, 'finish', (error, result) -> console.log error if error

    "click .cancel-command": (event, template) ->
      Meteor.call "updateDelivery", @_id, 'cancel', (error, result) -> console.log error if error

    "click .accounting-command": ->
      Meteor.call 'confirmReceiveSale', @sale, (error, result) -> if error then console.log error

    "click .export-command": ->
      Meteor.call 'createSaleExport', @sale, (error, result) -> if error then console.log error

    "click .import-command": ->
      Meteor.call 'createSaleImport', @sale, (error, result) -> if error then console.log error