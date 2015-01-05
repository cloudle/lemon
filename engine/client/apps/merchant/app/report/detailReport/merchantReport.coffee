scope = logics.merchantReport

lemon.defineApp Template.merchantReport,
  branchActiveClass: -> if Session.get("merchantReportBranchSelection")?._id is @_id then 'active' else ''
  multipleBranch: -> UI._templateInstance().data.branchList.count() > 1
  isRootBranch: -> @parent is undefined
  created: -> lemon.dependencies.resolve('merchantReport')
  events:
    "click .merchant-selection": (event, template) -> Session.set "merchantReportBranchSelection", @