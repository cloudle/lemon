scope = logics.merchantOptions
totalDecoratorTiles = 10
updateAllowEditBillDesign = (template) ->
  noChanges = (template.ui.$companyName.val() is scope.myMerchantProfile.companyName) and
               (template.ui.$companyAddress.val() is scope.myMerchantProfile.contactAddress) and
               (template.ui.$companyPhone.val() is scope.myMerchantProfile.contactPhone)

  Session.set("merchantOptionsCompanyInfoChanged", !noChanges)

updateCompanyInfo = (template) ->
  Schema.merchantProfiles.update scope.myMerchantProfile._id,
    $set:
      companyName: template.ui.$companyName.val()
      contactAddress: template.ui.$companyAddress.val()
      contactPhone: template.ui.$companyPhone.val()

  Session.set "merchantOptionsCompanyInfoChanged", false

lemon.defineHyper Template.merchantPrintDesigner,
  bodySpaceIterator: ->
    array = []
    array.push i for i in [0...totalDecoratorTiles]
    array
  allowUpdateDesigner: -> Session.get("merchantOptionsCompanyInfoChanged")
  rendered: -> console.log 'printDesignerRendered'
  events:
    "input .editable": (event, template) -> updateAllowEditBillDesign(template)
    "keyup .editable": (event, template) ->
      updateCompanyInfo(template) if event.which is 13
    "click .updateCompanyInfoCommand": (event, template) -> updateCompanyInfo(template)
    "click .printDesignPreview": (event, template) -> window.print()
