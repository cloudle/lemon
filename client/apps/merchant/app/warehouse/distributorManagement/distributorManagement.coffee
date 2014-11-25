scope = logics.distributorManagement

lemon.defineApp Template.distributorManagement,
  avatarUrl: -> if @avatar then AvatarImages.findOne(@avatar)?.url() else undefined
  currentDistributor: -> Session.get("distributorManagementCurrentDistributor")
  activeClass:-> if Session.get("distributorManagementCurrentDistributor")?._id is @._id then 'active' else ''
#  rendered: -> $(".nano").nanoScroller()
  events:
    "click .inner.caption": (event, template) -> Session.set("distributorManagementCurrentDistributor", @)
    "input input": (event, template) -> scope.checkAllowCreateDistributor(template)
    'click .create-distributor': (event, template)-> scope.createDistributor(template)
    "click .excel-distributor": (event, template) -> $(".excelFileSource").click()
    "change .excelFileSource": (event, template) ->
      if event.target.files.length > 0
        console.log 'importing'
        $excelSource = $(".excelFileSource")
        $excelSource.parse
          config:
            complete: (results, file) ->
              console.log file, results
              Apps.Merchant.importFileDistributorCSV(results.data)
        $excelSource.val("")