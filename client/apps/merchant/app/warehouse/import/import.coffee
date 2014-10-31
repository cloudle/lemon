lemon.defineApp Template.import,



  rendered: ->
#    $(@find '#productPopover').modalPopover
#      target: '#popProduct'
#      backdrop: true
#      placement: 'bottom'
#    $(@find '#providerPopover').modalPopover
#      target: '#popProvider'
#      backdrop: true
#      placement: 'bottom'


  events:
#    "click #popProduct": (event, template) -> $(template.find '#productPopover').modalPopover('show')
#    "click #popProvider": (event, template) -> $(template.find '#providerPopover').modalPopover('show')

    'click .addImportDetail': (event, template)->
      option =
        product      : Session.get('currentImport').currentProduct
        importQuality: Session.get('currentImport').currentQuality
        importPrice  : Session.get('currentImport').currentImportPrice
        provider     : Session.get('currentImport').currentProvider
        expire       : logics.import.getExpireDate('expire')
        salePrice    : Session.get('currentImport').currentPrice if Session.get('currentImport').currentPrice

      logics.import.addImportDetail(option, Session.get('currentImport')._id)

    'click .finishImport': (event, template)-> logics.import.finish(Session.get('currentImport')._id)
    'click .editImport'  : (event, template)-> logics.import.enabledEdit(Session.get('currentImport')._id)
    'click .submitImport': (event, template)-> logics.import.submit(Session.get('currentImport')._id)
    'blur .description': (event, template)->logics.import.updateDescription(template.find(".description").value, currentImportId)
    'blur .deposit': (event, template)->logics.import.updateDeposit(template.find(".description").value, currentImportId)


