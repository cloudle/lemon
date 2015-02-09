scope = logics.customerManagement

lemon.defineApp Template.customerManagement,
  showFilterSearch: -> Session.get("customerManagementSearchFilter")?.length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentCustomer: -> Session.get("customerManagementCurrentCustomer")
  activeClass:-> if Session.get("customerManagementCurrentCustomer")?._id is @._id then 'active' else ''
  creationMode: -> Session.get("customerManagementCreationMode")
  firstName: -> Helpers.firstName(@name)

  finalDebtBalance: -> Session.get("customerManagementCurrentCustomer")?.customSaleDebt + Session.get("customerManagementCurrentCustomer")?.saleDebt
#  rendered: -> $(".nano").nanoScroller()
  created: ->
    permission = Role.hasPermission(Session.get("myProfile"), Apps.Merchant.TempPermissions.customerStaff.key)
    if !permission then Router.go('/merchant')

    lemon.dependencies.resolve('customerManagement')
    Session.set("customerManagementSearchFilter", "")
    if Session.get("mySession")
      currentCustomer = Session.get("mySession").currentCustomerManagementSelection
      limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
      if !currentCustomer
        if customer = Schema.customers.findOne()
          UserSession.set("currentCustomerManagementSelection", customer._id)
          Meteor.subscribe('customerManagementData', customer._id, 0, limitExpand)
          Session.set("customerManagementDataMaxCurrentRecords", limitExpand)
          Session.set("customerManagementCurrentCustomer", customer)
      else
        Meteor.subscribe('customerManagementData', currentCustomer, 0, limitExpand)
        Session.set("customerManagementDataMaxCurrentRecords", limitExpand)
        Session.set("customerManagementCurrentCustomer", Schema.customers.findOne(currentCustomer))

  events:
    "input .search-filter": (event, template) ->
      Helpers.deferredAction ->
        Session.set("customerManagementSearchFilter", template.ui.$searchFilter.val())
      , "customerManagementSearchPeople"
    "keypress input[name='searchFilter']": (event, template)->
      scope.createCustomer(template) if event.which is 13 and Session.get("customerManagementCreationMode")
    "click .createCustomerBtn": (event, template) -> scope.createCustomer(template)

    "click .inner.caption": (event, template) ->
      if Session.get("mySession")
        Schema.userSessions.update(Session.get("mySession")._id, {$set: {currentCustomerManagementSelection: @_id}})
        limitExpand = Session.get("mySession").limitExpandSaleAndCustomSale ? 5
        if customer = Schema.customers.findOne(@_id)
          countRecords = Schema.customSales.find({buyer: customer._id}).count()
          countRecords += Schema.sales.find({buyer: customer._id}).count() if customer.customSaleModeEnabled is false
          if countRecords is 0
            Meteor.subscribe('customerManagementData', customer._id, 0, limitExpand)
            Session.set("customerManagementDataMaxCurrentRecords", limitExpand)
          else
            Session.set("customerManagementDataMaxCurrentRecords", countRecords)
          Session.set("customerManagementCurrentCustomer", customer)

        Session.set("allowCreateCustomSale", false)
        Session.set("allowCreateTransactionOfCustomSale", false)

#    "input input": (event, template) -> scope.checkAllowCreate(template)
#    "click #createCustomerAccount": (event, template) -> scope.createNewCustomer(template)
#
#    "click .excel-customer": (event, template) -> $(".excelFileSource").click()
#    "change .excelFileSource": (event, template) ->
#      if event.target.files.length > 0
#        console.log 'importing'
#        $excelSource = $(".excelFileSource")
#        $excelSource.parse
#          config:
#            complete: (results, file) ->
#              console.log file, results
#              Apps.Merchant.importFileCustomerCSV(results.data)
#        $excelSource.val("")
