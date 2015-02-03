scope = logics.agencyProductManagement

lemon.defineApp Template.agencyProductManagement,
  showFilterSearch: -> Session.get(scope.agencyProductManagementProductSearchFilter)?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentProduct: -> Session.get(scope.agencyProductManagementCurrentProduct )
  activeClass:-> if Session.get(scope.agencyProductManagementCurrentProduct )?._id is @._id then 'active' else ''
  creationMode: -> Session.get(scope.agencyProductManagementProductCreationMode)
#  rendered: -> $(".nano").nanoScroller()
  created: ->
    lemon.dependencies.resolve('productManagement')
    Session.set scope.agencyProductManagementProductSearchFilter
    if currentProductIdFound = Session.get("mySession")?[scope.agencyProductManagementCurrentProductId]
      Meteor.subscribe('productManagementData', currentProductIdFound)
      Session.set scope.agencyProductManagementCurrentProduct, Schema.products.findOne(currentProductIdFound)

  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set(scope.agencyProductManagementProductSearchFilter, template.ui.$searchFilter.val())
      , "agencyProductManagementSearchProduct"

    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get(scope.agencyProductManagementProductSearchFilter)?.trim()?.length > 1
        scope.createProduct(template)
    "click .createProductBtn": (event, template) -> scope.createProduct(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        UserSession.set(scope.agencyProductManagementCurrentProductId, @_id)
        Meteor.subscribe('productManagementData', @_id)
