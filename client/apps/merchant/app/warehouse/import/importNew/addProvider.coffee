lemon.defineWidget Template.addProvider,
  events:
    'click .create-provider': (event, template)-> logics.import.createNewProvider(event, template)
    'click .delete-provider': (event, template)-> logics.import.removeNewProvider(@_id)



