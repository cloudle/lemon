lemon.defineWidget Template.importHistoryThumbnail,
  createDate: (date) -> moment(date).format("DD/MM/YYYY")

  events:
    'click .full-desc.trash': (event, template) ->
      UserSession.get('currentInventoryHistory', @_id)
      console.log ("from Thumbnail")
      event.stopPropagation()
