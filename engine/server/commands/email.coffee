Meteor.methods
  mailTo: (to, from, subject, text) ->
    @unblock()
    Email.send
      to: to
      from: from
      subject: subject
      text: text