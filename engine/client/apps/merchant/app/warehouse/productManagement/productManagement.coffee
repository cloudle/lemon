scope = logics.productManagement

lemon.defineApp Template.productManagement,
  showFilterSearch: -> Session.get("productManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentProduct: -> Session.get("productManagementCurrentProduct")
  activeClass:-> if Session.get("productManagementCurrentProduct")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("productManagementCreationMode")

  showBranchProductList   :-> @managedBranchProductList.length > 0
  showMerchantProductList :-> @managedMerchantProductList.length > 0
  showGeraProductList     :-> @managedGeraProductList.length > 0

  created: ->
    if currentProduct = Session.get("mySession")?.currentProductManagementSelection
      Meteor.subscribe('productManagementData', currentProduct)
      Session.set("productManagementCurrentProduct", Schema.products.findOne(currentProduct))

    lemon.dependencies.resolve('productManagements')
    Session.set("productManagementSearchFilter", "")



  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("productManagementSearchFilter", template.ui.$searchFilter.val())
      , "productManagementSearchProduct"

    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get("productManagementSearchFilter")?.trim().length > 1
        scope.createProduct(template)
    "click .createProductBtn": (event, template) -> scope.createProduct(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentProductManagementSelection: @_id}})
        Meteor.subscribe('productManagementData', @_id)