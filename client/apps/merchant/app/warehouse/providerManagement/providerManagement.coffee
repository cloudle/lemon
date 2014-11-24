scope = logics.providerManagement

lemon.defineApp Template.providerManagement,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentProvider: -> Session.get("providerManagementCurrentProvider")
  activeClass:-> if Session.get("providerManagementCurrentProvider")?._id is @._id then 'active' else ''
#  rendered: -> $(".nano").nanoScroller()
  events:
    "click .inner.caption": (event, template) -> Session.set("providerManagementCurrentProvider", @)
    "input input": (event, template) -> scope.checkAllowCreateProvider(template)
    'click .create-provider': (event, template)-> scope.createProvider(template)
    "click .excel-provider": (event, template) -> $(".excelFileSource").click()
    "change .excelFileSource": (event, template) ->
      if event.target.files.length > 0
        console.log 'importing'
        $excelSource = $(".excelFileSource")
        $excelSource.parse
          config:
            complete: (results, file) ->
              console.log file, results
              Apps.Merchant.importFileProviderCSV(results.data)
        $excelSource.val("")