lemon.defineWidget Template.importHistoryThumbnail,
  createDate: (date) -> moment(date).format("DD/MM/YYYY")

  events:
    'click .full-desc.trash': -> UserSession.get('currentInventoryHistory', @_id)
