lemon.defineWidget Template.returnProductThumbnail,
  events:
    "dblclick .trash": -> logics.returns.removeReturnDetail(@_id)