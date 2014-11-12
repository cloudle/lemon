lemon.defineWidget Template.transactionManagerDetail,
  createDate: ->
    if @transaction?.debtDate
      moment(@transaction.debtDate).format("DD/MM/YYYY")
  groupType: (group) ->
    switch group
      when 'sale' then 'Phiếu bán hàng'
      when 'import' then 'Phiếu nhập hàng'
      when 'customer' then 'Phiếu nợ'

  status: -> if @transaction?.debitCash > 0 then 'Còn nợ' else 'Hết nợ'
  countDetail: -> @transactionDetail?.count() ? 0

  hideAddDetail: -> !Session.get('showAddTransactionDetail')
  showDeleteTransaction: -> if @transactionDetail?.count() is 0 and !Session.get('showAddTransactionDetail') then true

  depositCashOptions:
    reactiveSetter: (val) -> logics.transactionManager.depositCashNewTransactionDetail = val
    reactiveValue: -> logics.transactionManager.depositCashNewTransactionDetail ? 0
    reactiveMax: -> Session.get('currentTransaction')?.debitCash ? 0
    reactiveMin: -> 0
    reactiveStep: -> 10000

  rendered: ->
  events:
    "click .showTransactionDetail": (event, template) -> Session.set('showAddTransactionDetail', true)
    "click .deleteTransaction": (event, template) -> Meteor.call 'deleteTransaction', @transaction._id
    "click .cancelCreateTransactionDetail": (event, template) -> Session.set('showAddTransactionDetail', false)
    "click .createTransactionDetail": (event, template) ->
      TransactionDetail.newByUser(logics.transactionManager.depositCashNewTransactionDetail , Session.get('currentTransaction')._id)
      logics.transactionManager.depositCashNewTransactionDetail = 0

