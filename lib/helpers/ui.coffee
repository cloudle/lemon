Helpers.animateUsing = (selector, animationType) ->
  $element = $(selector)
  $element.removeClass()
  .addClass("animated #{animationType}")
  .one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', -> $element.removeClass())
