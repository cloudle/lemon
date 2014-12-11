scope = logics.distributorManagement

lemon.defineApp Template.distributorManagement,
  showFilterSearch: -> Session.get("distributorManagementSearchFilter").length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentDistributor: -> Session.get("distributorManagementCurrentDistributor")
  activeClass:-> if Session.get("distributorManagementCurrentDistributor")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("distributorCreationMode")
#  rendered: -> $(".nano").nanoScroller()
  created: ->
    lemon.dependencies.resolve('distributorManagement')
    Session.set("distributorManagementSearchFilter", "")

    if Session.get("mySession")
      currentDistributor = Session.get("mySession").currentDistributorManagementSelection
      limitExpand = Session.get("mySession").limitExpandImportAndCustomImport ? 5
      if !currentDistributor
        if distributor = Schema.distributors.findOne()
          UserSession.set("currentCustomerManagementSelection", distributor._id)
          Meteor.subscribe('distributorManagementData', distributor._id, 0, limitExpand)
          Session.set("distributorManagementDataMaxCurrentRecords", limitExpand)
          Session.set("distributorManagementCurrentCustomer", distributor)
      else
        Meteor.subscribe('distributorManagementData', currentDistributor, 0, limitExpand)
        Session.set("distributorManagementDataMaxCurrentRecords", limitExpand)
        Session.set("distributorManagementCurrentCustomer", Schema.distributors.findOne(currentDistributor))

  events:
    "input .search-filter": (event, template) ->
      Session.set("distributorManagementSearchFilter", template.ui.$searchFilter.val())

    "keypress input[name='searchFilter']": (event, template)->
      if event.which is 13 and Session.get("distributorManagementSearchFilter")?.trim().length > 1 and Session.get("distributorCreationMode")
        scope.createDistributorBySearchFilter(template)

    "click .createDistributorBtn": (event, template) ->
      scope.createDistributorBySearchFilter(template) if Session.get("distributorCreationMode")

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentDistributorManagementSelection: @_id}})
        limitExpand = Session.get("mySession").limitExpandImportAndCustomImport ? 5
        if distributor = Schema.distributors.findOne(@_id)
          countRecords = Schema.customImports.find({seller: distributor._id}).count()
          countRecords += Schema.imports.find({distributor: distributor._id, finish: true, submitted: true}).count() if distributor.customImportModeEnabled is false
          if countRecords is 0
            Meteor.subscribe('distributorManagementData', distributor._id, 0, limitExpand)
            Session.set("distributorManagementDataMaxCurrentRecords", limitExpand)
          else
            Session.set("distributorManagementDataMaxCurrentRecords", countRecords)
          Session.set("distributorManagementCurrentCustomer", distributor)

        Session.set("allowCreateCustomImport", false)
        Session.set("allowCreateTransactionOfCustomImport", false)

#
#    "click .excel-distributor": (event, template) -> $(".excelFileSource").click()
#    "change .excelFileSource": (event, template) ->
#      if event.target.files.length > 0
#        console.log 'importing'
#        $excelSource = $(".excelFileSource")
#        $excelSource.parse
#          config:
#            complete: (results, file) ->
#              console.log file, results
#              Apps.Merchant.importFileDistributorCSV(results.data)
#        $excelSource.val("")