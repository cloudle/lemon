scope = logics.customerManagement

lemon.defineApp Template.customerManagement,
  showFilterSearch: -> Session.get("customerManagementSearchFilter").length > 0
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentCustomer: -> Session.get("customerManagementCurrentCustomer")
  activeClass:-> if Session.get("customerManagementCurrentCustomer")?._id is @._id then 'active' else ''
#  rendered: -> $(".nano").nanoScroller()
  created: ->
    Session.setDefault('allowCreateNewCustomer', false)
  events:
    "input .search-filter": (event, template) -> Session.set("customerManagementSearchFilter", template.ui.$searchFilter.val())
    "click .inner.caption": (event, template) -> Session.set("customerManagementCurrentCustomer", @)
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