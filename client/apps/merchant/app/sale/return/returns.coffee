lemon.defineApp Template.returns,
  hideAddReturnDetail: -> return "display: none" unless logics.returns.currentSale || logics.returns.currentReturn?.status == 0
  hideFinishReturn: -> return "display: none" if logics.returns.currentReturn?.status != 0
  hideEditReturn:   -> return "display: none" if logics.returns.currentReturn?.status != 1
  hideSubmitReturn: -> return "display: none" if logics.returns.currentReturn?.status != 1

  events:
    'click .addReturnDetail': (event, template) -> logics.returns.addReturnDetail(Session.get('currentSale')._id)
    'click .finishReturn'   : (event, template) -> logics.returns.finishReturn(logics.returns.currentReturn._id) if logics.returns.currentReturn
    'click .editReturn'     : (event, template) -> logics.returns.editReturn(logics.returns.currentReturn._id) if logics.returns.currentReturn
    'click .submitReturn'   : (event, template) -> logics.returns.submitReturn(logics.returns.currentReturn._id) if logics.returns.currentReturn