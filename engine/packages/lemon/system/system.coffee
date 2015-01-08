finishAfterCurrentVersion = (currentVersion) -> {'version.updateAt': {$gt: currentVersion.updateAt}}
doneKPIs = { status: 'done' }

getNextVersion = (currentVersion, step) ->
  subversion = currentVersion.version.substring(2)
  version = currentVersion.version.substring(0,1)

  nextSubversion = Math.round((Number(subversion) + step)*10)/10
  if nextSubversion > 10
    nextSubversion = Math.round((nextSubversion - 10)*10)/10
    version++

  "#{version}.#{nextSubversion}"

Schema.add 'systems', "System", class System
  @init: -> Schema.systems.insert({version: '0.0.1' }) if Schema.systems.find().count() is 0
  @upgrade: (step = 0.1) ->
    currentVersion = @schema.findOne()
    nextVersion = getNextVersion(currentVersion, step)

    updates = Schema.kaizens.find({$and: [doneKPIs, finishAfterCurrentVersion(currentVersion)]}).fetch()

    if updates.length is 0
      console.log "Upgrading cancelled, there is no change since previous update!"
    else
      for update in updates
        Schema.migrations.insert
          systemVersion: nextVersion
          description: update.description
          creator: update.creator
          owner: update.owner
          group: [update.group]

      @schema.update(currentVersion._id, {$set: {version: nextVersion}})
      console.log "System successfully upgraded to version #{nextVersion}"

  @checkUpdates: ->
    currentVersion = Schema.systems.findOne()
    updates = Schema.kaizens.find({$and: [doneKPIs, finishAfterCurrentVersion(currentVersion)]}).fetch()
    console.log "There is #{updates.length} updates since previous version:"
    console.log "#{update.group}: #{update.description}" for update in updates

if Meteor.isClient
  Meteor.subscribe('system')