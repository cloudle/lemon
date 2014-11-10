currentIndex = 0
colors = [
  '#54c8eb', # light blue
  '#4ea9de', # med blue
  '#4b97d2', # dark blue
  '#92cc8f', # light green
  '#41bb98', # mint green
  '#c9de83', # yellowish green
  '#dee569', # yellowisher green
  '#c891c0', # light purple
  '#9464a8', # med purple
  '#7755a1', # dark purple
  '#f069a1', # light pink
  '#f05884', # med pink
  '#e7457b', # dark pink
  '#ffd47e', # peach
  '#f69078'  # salmon
]

animateBackgroundColor = ->
  console.log 'animating...'
  $(".animated-bg").css("background-color", colors[currentIndex])
  currentIndex++
  currentIndex = 0 if currentIndex > colors.length

lemon.defineWidget Template.home,
  rendered: ->

    self = @
    Meteor.setTimeout ->
      animateBackgroundColor()
      self.bgInterval = Meteor.setInterval(animateBackgroundColor, 15000)
    , 5000
  destroyed: -> Meteor.clearInterval(@bgInterval)

  events:
    "click #authButton.valid": (event, template) -> logics.homeHeader.login(event, template)
    "click #gotoMerchantButton": -> Router.go('/merchant')
    "click #logoutButton": -> lemon.logout()
    "keypress .login-field": (event, template) ->
      $(template.find("#authButton")).click() if event.which is 13 and Session.get('loginValid') is 'valid'

    "input .login-field": (event, template) ->
      $login    = $(template.find("#authAlias"))
      $password = $(template.find("#authSecret"))
      if $login.val().length > 0 and $password.val().length > 0
        Session.set('loginValid', 'valid')
      else
        Session.set('loginValid', 'invalid')