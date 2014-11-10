arrangeLayout = -> $(".animated-bg").css('height', $(window).height())

lemon.defineWidget Template.homeLayout,
  rendered: ->
    arrangeLayout()
    $(window).resize -> arrangeLayout()
  destroyed: -> $(window).off("resize")