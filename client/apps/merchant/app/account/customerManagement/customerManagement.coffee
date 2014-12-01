scope = logics.customerManagement

lemon.defineApp Template.customerManagement,
  showFilterSearch: -> Session.get("customerManagementSearchFilter").length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentCustomer: -> Session.get("customerManagementCurrentCustomer")
  activeClass:-> if Session.get("customerManagementCurrentCustomer")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("customerManagementCreationMode")
#  rendered: -> $(".nano").nanoScroller()
  created: ->
    Session.setDefault('allowCreateNewCustomer', false)
  events:
    "input .search-filter": (event, template) -> Session.set("customerManagementSearchFilter", template.ui.$searchFilter.val())
    "keypress input[name='searchFilter']": (event, template)->
      scope.createCustomer(template) if event.which is 13 and Session.get("customerManagementSearchFilter")?.trim().length > 1
    "click .createCustomerBtn": (event, template) -> scope.createCustomer(template)

    "click .inner.caption": (event, template) ->
      Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentCustomerManagementSelection: @_id}})
      Meteor.subscribe('customerManagementData', @_id)
#      UserSession.set("currentCustomerManagementSelection", @_id)

    "input input": (event, template) -> scope.checkAllowCreate(template)
    "click #createCustomerAccount": (event, template) -> scope.createNewCustomer(template)
    "click .excel-customer": (event, template) -> $(".excelFileSource").click()
    "change .excelFileSource": (event, template) ->
      if event.target.files.length > 0
        console.log 'importing'
        $excelSource = $(".excelFileSource")
        $excelSource.parse
          config:
            complete: (results, file) ->
              console.log file, results
              Apps.Merchant.importFileCustomerCSV(results.data)
        $excelSource.val("")