scope = logics.productManagement

lemon.defineApp Template.productManagement,
  showFilterSearch: -> Session.get("productManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentProduct: -> Session.get("productManagementCurrentProduct")
  activeClass:-> if Session.get("productManagementCurrentProduct")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("productManagementCreationMode")
  showDeleteBranchProduct: -> @inStockQuality == @availableQuality == @totalQuality == @salesQuality == 0
  showDeleteMerchantProduct: -> if @buildInProduct and @branchList?.length is 0 then true else false

  showBranchProductList   :-> @managedBranchProductList.length > 0
  showMerchantProductList :-> @managedMerchantProductList.length > 0
  showGeraProductList     :-> @managedGeraProductList.length > 0

  created: ->
#    Apps.Merchant.checkHasPermission("productStaff", "product")
    if currentProduct = Session.get("mySession").currentProductManagementSelection
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

    "click .deleteBranchProduct":  (event, template) ->
      Meteor.call('deleteBranchProduct', @_id); event.stopPropagation()
    "click .deleteMerchantProduct":  (event, template) ->
      Meteor.call('deleteMerchantProduct', @_id); event.stopPropagation()
    "click .addBranchProduct":  (event, template) ->
      Meteor.call('addBranchProduct', @_id); event.stopPropagation()
    "click .addMerchantAndBranchProduct":  (event, template) ->
      Meteor.call('getBuildInProduct', @_id); event.stopPropagation()
