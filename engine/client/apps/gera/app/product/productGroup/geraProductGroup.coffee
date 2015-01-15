scope = logics.geraProductGroup

lemon.defineApp Template.geraProductGroup,
  showFilterSearch: -> Session.get("geraProductGroupSearchFilter")?.length > 0
  avatarUrl: -> if @image then AvatarImages.findOne(@image)?.url() else undefined
  currentProductGroup: -> Session.get("geraProductGroupCurrentProductGroup")
  activeClass:-> if Session.get("geraProductGroupCurrentProductGroup")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("geraProductGroupCreationMode")

  created: ->
#    lemon.dependencies.resolve('availableBuildInProducts')
    Meteor.subscribe('availableGeraProductGroups')
    Session.set("geraProductGroupSearchFilter", "")

  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("geraProductGroupSearchFilter", template.ui.$searchFilter.val())
      , "geraProductGroupSearchProductGroup"

    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get("geraProductGroupSearchFilter")?.trim().length > 1
        scope.createGeraProductGroup(template)

    "click .createProductBtn": (event, template) ->
      if Session.get("geraProductGroupSearchFilter")?.trim().length > 1
        scope.createGeraProductGroup(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentGeraProductGroupSelection: @_id}})