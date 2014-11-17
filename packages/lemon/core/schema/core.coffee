root = global ? window

exceptions = ['helpers']

extendObject = (source, destination) ->
  destination[name] = value for name, value of source when !_(exceptions).contains(name)
  destination.prototype[name] = value for name, value of source.prototype

generateSchema = (name) ->
  Schema[name] = new Meteor.Collection name
  Schema[name].helpers(extensionObj.helpers) if extensionObj?.helpers
  Schema[name].attachSchema simpleSchema[name]

generateModel = (name, globalName, extensionObj) ->
  class root[globalName] extends modelBase
  extendObject extensionObj, root[globalName]
  root[globalName].schema = Schema[name]
  root[globalName].prototype.schema = Schema[name]

Schema.add = (name, globalName = undefined, extensionObj = undefined) ->
  generateSchema(name)
  generateModel(name, globalName, extensionObj) if extensionObj and globalName

Schema.list = ->
  i = 1
  (console.log "#{i}. #{name}"; i++) for name, value of Schema when value instanceof Mongo.Collection
  return