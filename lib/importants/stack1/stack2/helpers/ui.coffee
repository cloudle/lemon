Helpers.animateUsing = (selector, animationType) ->
  $element = $(selector)
  $element.removeClass()
  .addClass("animated #{animationType}")
  .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', -> $element.removeClass())

Helpers.excuteAfterAnimate = ($element, pureClass, animationType, commands) ->
  $element.removeClass()
  .addClass("#{pureClass} animated #{animationType}")
  .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', -> commands())

Helpers.arrangeAppLayout = Component.helpers.arrangeAppLayout