#returnQuality= ->
#  findReturnDetail =_.findWhere(Session.get('currentReturnDetails'),{
#    productDetail   : Session.get('currentProductDetail').productDetail
#    discountPercent : Session.get('currentProductDetail').discountPercent
#  })
#  if findReturnDetail
#    Session.get('currentProductDetail')?.quality - (Session.get('currentProductDetail')?.returnQuality + findReturnDetail.returnQuality)
#  else
#    Session.get('currentProductDetail')?.quality - Session.get('currentProductDetail')?.returnQuality
#
#runInitReturnsTracker = (context) ->
#  return if Sky.global.returnTracker
#  Sky.global.returnTracker = Tracker.autorun ->
#    if Session.get('currentWarehouse')
#      Session.set "availableSales", Schema.sales.find({warehouse: Session.get('currentWarehouse')._id, status: true, submitted: true, returnLock: false}).fetch()
#
#
#    if Session.get('availableSales')?.length > 0
#      if Session.get('currentProfile')?.currentSale
#        Session.set 'currentSale', Schema.sales.findOne(Session.get('currentProfile')?.currentSale)
#    else
#      Session.set 'currentSale'
#
#    if Session.get('currentSale')
#      Session.set 'currentReturn', Schema.returns.findOne({sale: Session.get('currentSale')._id, status: {$ne: 2}})
#      Session.set 'currentSaleProductDetails', Schema.saleDetails.find({sale: Session.get('currentSale')._id}).fetch()
#
#    if Session.get('currentSale')?.currentProductDetail
#      Session.set 'currentProductDetail', Schema.saleDetails.findOne(Session.get('currentSale')?.currentProductDetail)
#
#    if Session.get('currentReturn')
#      Session.set 'currentReturnDetails', Schema.returnDetails.find({return: Session.get('currentReturn')._id}).fetch()
#    else
#      Session.set 'currentReturnDetails'
#
#    if Session.get('currentProductDetail')
#      Session.set 'currentMaxQualityReturn', returnQuality()

lemon.defineApp Template.returns,
  hideAddReturnDetail: -> return "display: none" if Session.get('currentReturn') and Session.get('currentReturn')?.status != 0
  hideFinishReturn: -> return "display: none" if Session.get('currentReturn')?.status != 0
  hideEditReturn:   -> return "display: none" if Session.get('currentReturn')?.status != 1
  hideSubmitReturn: -> return "display: none" if Session.get('currentReturn')?.status != 1

  events:
    'click .addReturnDetail': (event, template) -> ReturnDetail.addReturnDetail(Session.get('currentSale')._id)
    'click .finishReturn'   : (event, template) -> Return.findOne(Session.get('currentReturn')._id).finishReturn() if Session.get('currentReturn')
    'click .editReturn'     : (event, template) -> Return.findOne(Session.get('currentReturn')._id).editReturn() if Session.get('currentReturn')
    'click .submitReturn'   : (event, template) -> Return.findOne(Session.get('currentReturn')._id).submitReturn() if Session.get('currentReturn')