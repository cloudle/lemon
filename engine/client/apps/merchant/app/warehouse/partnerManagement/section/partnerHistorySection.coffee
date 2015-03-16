scope = logics.partnerManagement

lemon.defineHyper Template.partnerManagementPartnerHistorySection,
  oldHistoryPartner: ->
    partnerImportList  = Schema.imports.find({partner: @_id, status: 'success'}, {sort: {'version.createdAt': 1}}).fetch()
    partnerSaleList    = Schema.partnerSales.find({partner: @_id, status: 'success'}, {sort: {'version.createdAt': 1}}).fetch()
    partnerTransaction = Schema.transactions.find({owner: @_id,  group: 'partner', status: 'success'}, {sort: {'version.createdAt': 1}}).fetch()

    if @status is 'myMerchant'
      sorted = _.sortBy partnerImportList.concat(partnerTransaction), (item) -> item.version.createdAt
    else
      sorted = _.sortBy partnerImportList.concat(partnerSaleList).concat(partnerTransaction), (item) -> item.version.createdAt

    sorted[0].transactionFirst = true if sorted[0]?.group
    return sorted

  newHistoryPartner: ->
    partnerImportList  = Schema.imports.find({partner: @_id, status: 'unSubmit'}, {sort: {'version.createdAt': 1}}).fetch()
    partnerSaleList    = Schema.partnerSales.find({partner: @_id, status: 'unSubmit'}, {sort: {'version.createdAt': 1}}).fetch()
    partnerTransaction = Schema.transactions.find({owner: @_id, group: 'partner', status: $in:['unSubmit', 'submit']}, {sort: {'version.createdAt': 1}}).fetch()

    if partnerSaleList.length > 0 then partnerSaleList[0].isSaleFirst = true
    sorted = _.sortBy partnerImportList.concat(partnerSaleList).concat(partnerTransaction), (item) -> item.version.createdAt
    beforeDebtBalance = @saleCash + @paidCash - @importCash - @receiveCash
    for item in sorted
      beforeDebtBalance +=
        if item.partnerSale then -item.debtBalanceChange
        else if item.partnerImport then +item.debtBalanceChange
        else if item.receivable is true then  -item.debtBalanceChange else item.debtBalanceChange
      item.latestDebtBalance = beforeDebtBalance

    if sorted[0]
      sorted[0].isFirst = true
      sorted[0].transactionFirst = true if sorted[0].group

    sorted

  finalDebtBalance: -> @saleCash + @paidCash - @importCash - @receiveCash
  safeClass: ->
    if @partnerImport then ''
    else if @partnerSale then 'safe'
    else if @receivable then 'safe'
    else ''

  rendered: ->
    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .transactionPaid": (event, template) ->
      $payAmount = template.ui.$payAmount
      $payDescription = template.ui.$payDescription
      payAmount = Math.abs $payAmount.inputmask('unmaskedvalue')
      Meteor.call 'createTransactionOfPartner', @_id, payAmount, $payDescription.val(), 'paid', (error, result) ->
        if error then console.log error.error else $payDescription.val(''); $payAmount.val('')

    "click .transactionReceive": (event, template) ->
      $payAmount = template.ui.$payAmount
      $payDescription = template.ui.$payDescription
      payAmount = Math.abs $payAmount.inputmask('unmaskedvalue')
      Meteor.call 'createTransactionOfPartner', @_id, payAmount, $payDescription.val(), 'receive', (error, result) ->
        if error then console.log error.error else $payDescription.val(''); $payAmount.val('')
