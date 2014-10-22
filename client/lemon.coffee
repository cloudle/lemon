#Session.setDefault("counter", 0)
#
#lemon.defineApp Template.hello,
#  counter: -> Session.get("counter")
#  avatarImages: -> AvatarImages.find()
#  dumpRecords: -> Schema.dumpCollections.find({})
#
#  events:
#    "click button": ->  Session.set("counter", Session.get("counter") + 1)
#    "change .uploader": (event, template) ->
#      console.log 'uploader changed'
#      files = event.target.files
#      if files.length > 0
#        AvatarImages.insert files[0], (error, fileObj) ->
#          console.log 'uploaded', fileObjs