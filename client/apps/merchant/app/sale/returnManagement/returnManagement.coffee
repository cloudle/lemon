scope = logics.returnManagement

lemon.defineApp Template.returnManagement,
  allowCreateOrderDetail: -> if !scope.currentProduct then 'disabled'

  created: ->
    lemon.dependencies.resolve('returnManagement')

  rendered: ->
    console.log Session.get('mySession').currentReturn

#  events:
#    "input .search-filter": (event, template) ->
#      Session.set("salesCurrentProductSearchFilter", template.ui.$searchFilter.val())