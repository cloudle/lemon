lemon.defineWidget Template.inventoryHistoryDetail,
  status: ->
    if @inventory
      if @inventory.submit == false and @inventory.success == false then return 'Đang kiểm kho'
      if @inventory.submit == true and @inventory.success == false then return 'Kho có vấn đề.'
      if @inventory.submit == true and @inventory.success == true then return 'Kho không có vấn đề.'

  events:
    "click .finish": (event, template) ->
      if @inventory.import?.submitted is true and @inventory.import?.finish is false
        logics.import.finish(@inventory.import._id)