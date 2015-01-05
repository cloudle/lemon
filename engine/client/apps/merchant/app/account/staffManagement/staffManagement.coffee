scope = logics.staffManagement

lemon.defineApp Template.staffManagement,
  showFilterSearch: -> Session.get("staffManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  activeClass:-> if Session.get("staffManagementCurrentStaff")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("staffManagementCreationMode")
  firstName: -> Helpers.firstName(@fullName)
  finalDebtBalance: -> Session.get("staffManagementCurrentStaff")?.customSaleDebt + Session.get("staffManagementCurrentStaff")?.saleDebt

  created: ->
    lemon.dependencies.resolve('staffManagement')

    Session.set("staffManagementSearchFilter", "")
    if Session.get("mySession")
      currentStaffId = Session.get("mySession").currentStaffManagementSelection
      limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
      if currentStaffId
        staff = Schema.userProfiles.findOne(currentStaffId)
      else
        if staff = Schema.userProfiles.findOne()
          UserSession.set("currentStaffManagementSelection", staff._id)

      if staff
#        Meteor.subscribe('staffManagementData', currentStaffId, 0, limitExpand)
#        Session.set("staffManagementDataMaxCurrentRecords", limitExpand)
        Session.set("staffManagementCurrentStaff", staff)
        Session.set('currentRoleSelection', Schema.roles.find({_id: $in: staff.roles ? []}).fetch())



  events:
    "input .search-filter": (event, template) ->
      Session.set("staffManagementSearchFilter", template.ui.$searchFilter.val())
    "keypress input[name='searchFilter']": (event, template)->
      scope.createStaff(template) if event.which is 13 and Session.get("staffManagementCreationMode")
    "click .createStaffBtn": (event, template) -> scope.createStaff(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentStaffManagementSelection: @_id}})
        limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
        if staff = Schema.userProfiles.findOne(@_id)
#          countRecords = Schema.customSales.find({buyer: staff._id}).count()
#          countRecords += Schema.sales.find({buyer: staff._id}).count() if staff.customSaleModeEnabled is false
#          if countRecords is 0
#            Meteor.subscribe('staffManagementData', staff._id, 0, limitExpand)
#            Session.set("staffManagementDataMaxCurrentRecords", limitExpand)
#          else
#            Session.set("staffManagementDataMaxCurrentRecords", countRecords)
          Session.set("staffManagementCurrentStaff", staff)

        Session.set("allowCreateCustomSale", false)
        Session.set("allowCreateTransactionOfCustomSale", false)

        Session.set('currentRoleSelection', Schema.roles.find({_id: $in: staff.roles ? []}).fetch())

