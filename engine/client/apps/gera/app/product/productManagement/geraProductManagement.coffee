scope = logics.geraProductManagement

lemon.defineApp Template.geraProductManagement,
  showFilterSearch: -> Session.get("geraProductManagementSearchFilter")?.length > 0
  imageUrl: -> if @image then AvatarImages.findOne(@image)?.url() else undefined
  currentProduct: -> Session.get("geraProductManagementCurrentProduct")
  activeClass:-> if Session.get("geraProductManagementCurrentProduct")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("geraProductManagementCreationMode")

  created: ->
#    lemon.dependencies.resolve('availableBuildInProducts')
    Meteor.subscribe('availableBuildInProducts')
    Meteor.subscribe('availableGeraProductGroups')
    Meteor.subscribe('currentBuildInProductData')
    Session.set("geraProductManagementSearchFilter", "")

  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("geraProductManagementSearchFilter", template.ui.$searchFilter.val())
      , "geraProductManagementSearchProduct"

    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get("geraProductManagementSearchFilter")?.trim().length > 1
        scope.createGeraProduct(template)

    "click .createProductBtn": (event, template) ->
      if Session.get("geraProductManagementSearchFilter")?.trim().length > 1
        scope.createGeraProduct(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentGeraProductManagementSelection: @_id}})
#        Meteor.subscribe('productManagementData', @_id)