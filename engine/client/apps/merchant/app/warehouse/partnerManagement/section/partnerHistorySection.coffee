scope = logics.partnerManagement

lemon.defineHyper Template.partnerManagementPartnerHistorySection,
  finalDebtBalance: -> @saleCash + @paidCash - @importCash - @loanCash
  oldHistoryPartner: ->
    partnerImportList = Schema.imports.find({partner: @_id, status: 'success'}, {sort: {'version.createdAt': 1}}).fetch()
    partnerSaleList   = Schema.partnerSales.find({partner: @_id, status: 'success'}, {sort: {'version.createdAt': 1}}).fetch()
    if @status is 'myMerchant' then partnerImportList
    else  _.sortBy partnerImportList.concat(partnerSaleList), (item) -> item.version.createdAt

  newHistoryPartner: ->
    partnerImportList  = Schema.imports.find({partner: @_id, status: 'unSubmit'}, {sort: {'version.createdAt': 1}}).fetch()
    partnerSaleList    = Schema.partnerSales.find({partner: @_id, status: 'unSubmit'}, {sort: {'version.createdAt': 1}}).fetch()
    partnerTransaction = Schema.transactions.find({group: 'partner', status: 'unSubmit'}, {sort: {'version.createdAt': 1}}).fetch()

    if partnerSaleList.length > 0 then partnerSaleList[0].saleFirst = true
    else if partnerTransaction.length > 0 and partnerImportList.length is 0
      partnerTransaction[0].transactionFirst = true

    sorted = _.sortBy partnerImportList.concat(partnerSaleList).concat(partnerTransaction), (item) -> item.version.createdAt
    beforeDebtBalance = @saleCash + @paidCash - @importCash - @loanCash
    for item in sorted
      beforeDebtBalance +=
        if item.partnerSale then item.debtBalanceChange
        else if item.partnerImport then -item.debtBalanceChange
        else if item.receivable is true then -item.debtBalanceChange else item.debtBalanceChange
      item.latestDebtBalance = beforeDebtBalance

    sorted

  rendered: ->
#    @ui.$customImportDebtDate.inputmask("dd/mm/yyyy")
#    @ui.$paidDate.inputmask("dd/mm/yyyy")
#    @ui.$payAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})
#
#    @ui.$payImportAmount.inputmask("numeric",   {autoGroup: true, groupSeparator:",", radixPoint: ".", suffix: " VNĐ", integerDigits:11})

  events:
    "click .expandImportAndCustomImport": ->