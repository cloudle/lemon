scope = logics.partnerManagement

lemon.defineApp Template.partnerManagement,
  showFilterSearch: -> Session.get("partnerManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentPartner: -> Session.get("partnerManagementCurrentPartner")
  activeClass:-> if Session.get("partnerManagementCurrentPartner")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("partnerManagementCreationMode")
  showMyPartnerList: -> @managedMyPartnerList.length > 0
  showUnSubmitPartnerList: -> @managedUnSubmitPartnerList.length > 0
  showMerchantPartnerList: -> @managedMerchantPartnerList.length > 0
  showSubmitPartner: -> if @status is 'unSubmit' then true else false

  created: ->
    if currentPartner = Session.get("mySession").currentPartnerManagementSelection
      Meteor.subscribe('partnerManagementData', currentPartner)
      Session.set("partnerManagementCurrentPartner", Schema.partners.findOne(currentPartner))

    lemon.dependencies.resolve('partnerManagement')
    Session.set("partnerManagementSearchFilter", "")

  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("partnerManagementSearchFilter", template.ui.$searchFilter.val())
      , "partnerManagementSearchPartner"

    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get("partnerManagementSearchFilter")?.trim().length > 1
        scope.createPartner(template)
    "click .createPartnerBtn": (event, template) -> scope.createPartner(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        UserSession.set('currentPartnerManagementSelection', @_id)
        Meteor.subscribe('partnerManagementData', @_id)

    "click .submitMerchantPartner": (event, template) ->
      Meteor.call('updateMerchantPartner', @_id); event.stopPropagation()

    "click .addMerchantPartner": (event, template) ->
      Meteor.call('addMerchantPartner', @); event.stopPropagation()