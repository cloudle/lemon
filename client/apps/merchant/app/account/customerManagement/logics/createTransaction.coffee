Apps.Merchant.customerManagementInit.push (scope) ->
  scope.createTransaction = (event, template) ->

    if Session.get("customerManagementCurrentCustomer")
      customerId  = Session.get("customerManagementCurrentCustomer")._id
      $description = $(template.find('[name=description]'))
      $totalCash   = $(template.find('[name=totalCash]'))
      $depositCash = $(template.find('[name=depositCash]'))
      $debtDate    = $(template.find('[name=debtDate]'))

      if $description.val().length > 0 and $totalCash.val() > 0 and $totalCash.val() >= $depositCash.val() and moment($debtDate.val().toString(), "DD/MM/YYYY")._d < (new Date())
        Transaction.newByUser(
          customerId,
          $description.val(),
          $totalCash.val(),
          $depositCash.val(),
          moment($debtDate.val().toString(), "DD/MM/YYYY")._d
        )

        $description.val("")
        $totalCash.val("")
        $depositCash.val("")
        $debtDate.val("")