resetForm = (context) -> $(item).val('') for item in context.findAll("[name]")

logics.branchManager.createBranch = (context) ->
  name = context.ui.$name.val()
  address = context.ui.$address.val()
  if Schema.merchants.findOne({name: name})
    console.log 'Chi Nhanh Ton Tai'
  else
    Meteor.call 'createNewBranch', name, address, (error, result) ->
      if error
        console.log error.error
      else
        resetForm(context)
        Session.set('allowCreateNewBranch', false)
