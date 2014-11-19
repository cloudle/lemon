lemon.defineWidget Template.importHistoryDetail,
  showFinish: ->
    if Role.hasPermission(Session.get('myProfile')?._id, Apps.Merchant.Permissions.su.key)
      if @import?.finish is false and @import?.submitted is true then true
  status: ->
    if @import?.submitted is true and @import?.finish is false then return 'chờ xác nhận'
    if @import?.submitted is true and @import?.finish is true then return 'đã nhập kho'
  rendered: ->
  events:
    "click .finish": (event, template) ->
      if @import?.submitted is true and @import?.finish is false
        logics.import.finish(@import._id)