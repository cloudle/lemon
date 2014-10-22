Merchant.Controller = RouteController.extend
  layoutTemplate: 'merchantLayout'
  loadingTemplate: 'merchantLoadingLayout'
  fastRender: true
  waitOn: ->
    lemon.log 'waiting...'
#    Merchant.Subscriber.subscribe('fakeWaiter')
  data: ->
    lemon.log 'filtering data...'