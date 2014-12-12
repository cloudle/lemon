scope = logics.staffManagement

lemon.defineApp Template.staffManagement,
  showFilterSearch: -> Session.get("staffManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentStaff: -> Session.get("staffManagementCurrentStaff")
  activeClass:-> if Session.get("staffManagementCurrentStaff")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("staffManagementCreationMode")
  firstName: -> Helpers.firstName(@name)

  finalDebtBalance: -> Session.get("staffManagementCurrentStaff")?.customSaleDebt + Session.get("staffManagementCurrentStaff")?.saleDebt
#  rendered: -> $(".nano").nanoScroller()
  created: ->
    lemon.dependencies.resolve('staffManagement')
#    Session.setDefault('allowCreateNewStaff', false)
    Session.set("staffManagementSearchFilter", "")
    if Session.get("mySession")
      currentStaff = Session.get("mySession").currentStaffManagementSelection
      limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
      if !currentStaff
        if staff = Schema.staffs.findOne()
          UserSession.set("currentStaffManagementSelection", staff._id)
          Meteor.subscribe('staffManagementData', staff._id, 0, limitExpand)
          Session.set("staffManagementDataMaxCurrentRecords", limitExpand)
          Session.set("staffManagementCurrentStaff", staff)
      else
        Meteor.subscribe('staffManagementData', currentStaff, 0, limitExpand)
        Session.set("staffManagementDataMaxCurrentRecords", limitExpand)
        Session.set("staffManagementCurrentStaff", Schema.staffs.findOne(currentStaff))

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
        if staff = Schema.staffs.findOne(@_id)
          countRecords = Schema.customSales.find({buyer: staff._id}).count()
          countRecords += Schema.sales.find({buyer: staff._id}).count() if staff.customSaleModeEnabled is false
          if countRecords is 0
            Meteor.subscribe('staffManagementData', staff._id, 0, limitExpand)
            Session.set("staffManagementDataMaxCurrentRecords", limitExpand)
          else
            Session.set("staffManagementDataMaxCurrentRecords", countRecords)
          Session.set("staffManagementCurrentStaff", staff)

        Session.set("allowCreateCustomSale", false)
        Session.set("allowCreateTransactionOfCustomSale", false)

#    "input input": (event, template) -> scope.checkAllowCreate(template)
#    "click #createStaffAccount": (event, template) -> scope.createNewStaff(template)
#
#    "click .excel-staff": (event, template) -> $(".excelFileSource").click()
#    "change .excelFileSource": (event, template) ->
#      if event.target.files.length > 0
#        console.log 'importing'
#        $excelSource = $(".excelFileSource")
#        $excelSource.parse
#          config:
#            complete: (results, file) ->
#              console.log file, results
#              Apps.Merchant.importFileStaffCSV(results.data)
#        $excelSource.val("")
