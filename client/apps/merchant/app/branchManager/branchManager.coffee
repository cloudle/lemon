lemon.defineApp Template.branchManager,
  events:
    "input input": (event, template) -> logics.branchManager.checkAllowCreate(template)
    "click #createBranch": (event, template) -> logics.branchManager.createBranch(template)


