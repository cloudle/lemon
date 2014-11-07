lemon.defineWidget Template.importReviewDetail,
  showFinish: -> if @import?.finish is false and @import?.submitted is true then true
  status: ->
    if @import?.submitted is false and @import?.finish is false then return 'đang tạo'
    if @import?.submitted is true and @import?.finish is false then return 'chờ xác nhận'
    if @import?.submitted is true and @import?.finish is true then return 'đã nhập kho'
  rendered: ->
  events:
    "click": (event, template) ->
      console.log @