lemon.defineApp Template.importHistory,
  rendered: ->
    logics.importHistory.templateInstance = @
    $("[name=fromDate]").datepicker('setDate', Session.get('importHistoryFilterStartDate'))
    $("[name=toDate]").datepicker('setDate', Session.get('importHistoryFilterToDate'))

  events:
    "click .createImport": (event, template) -> Router.go('/import')
    "change [name='advancedMode']": (event, template) ->
      logics.importHistory.templateInstance.ui.extras.toggleExtra 'advanced', event.target.checked

    "click #filterImportHistories": (event, template)->
      Session.set('importHistoryFilterStartDate', $("[name=fromDate]").datepicker().data().datepicker.dates[0])
      Session.set('importHistoryFilterToDate', $("[name=toDate]").datepicker().data().datepicker.dates[0])

    "click .thumbnails:not(.full-desc.trash)": (event, template) ->
      Meteor.subscribe('importDetailInWarehouse', @_id)
      Session.set('currentImportHistory', @)
      $(template.find '#importHistoryDetail').modal()
