logics.branchManager = {}
Apps.Merchant.branchManagerInit = []

Apps.Merchant.branchManagerInit.push (scope) ->
  Session.setDefault('allowCreateNewBranch', false)
  logics.branchManager.availableBranch = []


logics.branchManager.reactiveRun = ->
  if Session.get('allowCreateNewBranch')
    logics.branchManager.allowCreate = ''
  else
    logics.branchManager.allowCreate = 'disabled'
