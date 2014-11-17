isCurrentPackage = (context) -> Session.get("currentMerchantPackage")?.packageClass is context.options.packageClass

lemon.defineWidget Template.merchantPriceTable,
  isActive: -> Session.get("currentMerchantPackage")?.packageClass is @options.packageClass
  showExtension: -> @options.packageClass isnt 'free' and isCurrentPackage(@)
  showAccountPlus: -> Session.get('wizardAccountPlus') > 0 and isCurrentPackage(@) and @options.packageClass isnt 'free'
  showBranchPlus: -> Session.get('wizardBranchPlus') > 0 and isCurrentPackage(@) and @options.packageClass isnt 'free'
  showWarehousePlus: -> Session.get('wizardWarehousePlus') > 0 and isCurrentPackage(@) and @options.packageClass isnt 'free'
  accountPlus: -> Session.get('wizardAccountPlus')
  branchPlus: -> Session.get('wizardBranchPlus')
  warehousePlus: -> Session.get('wizardWarehousePlus')

  realWarehouseLim: ->
    if @options.packageClass is 'free'
      @options.warehouseLim
    else
      @options.warehouseLim + Session.get('wizardBranchPlus')

  events:
    "click .command.raise.account": -> Session.set('wizardAccountPlus', Session.get('wizardAccountPlus') + 5)
    "click .command.raise.branch": -> Session.set('wizardBranchPlus', Session.get('wizardBranchPlus') + 1)
    "click .command.raise.warehouse": -> Session.set('wizardWarehousePlus', Session.get('wizardWarehousePlus') + 1)
    "click .command.lower.account": -> Session.set('wizardAccountPlus', Session.get('wizardAccountPlus') - 5) if Session.get('wizardAccountPlus') > 0
    "click .command.lower.branch": -> Session.set('wizardBranchPlus', Session.get('wizardBranchPlus') - 1) if Session.get('wizardBranchPlus') > 0
    "click .command.lower.warehouse": -> Session.set('wizardWarehousePlus', Session.get('wizardWarehousePlus') - 1) if Session.get('wizardWarehousePlus') > 0

#  extendPrice: ->
#    extendAccountPrice    = @options.extendAccountPrice * Session.get('extendAccountLimit')
#    extendBranchPrice     = @options.extendBranchPrice * Session.get('extendBranchLimit')
#    extendWarehousePrice  = @options.extendWarehousePrice * Session.get('extendWarehouseLimit')
#    extendAccountPrice + extendBranchPrice + extendWarehousePrice