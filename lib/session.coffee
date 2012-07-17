Util = require './util'

class Session
  constructor: (@name, files)->
    if files?
      @files = files
    else
      @files = []
  add: (filename)->
    idx = @files.indexOf(filename)
    if idx < 0
      @files.push filename
      @save()
  remove: (filename)->
    idx = @files.indexOf(filename)
    if idx >= 0
      @files.splice idx, 1
      @save()
  reset: ->
    @files = []
    @save()
  save: ->
    Session.save @name, @files

Session.parse = (name, data)->
  files = data.split '\n'
  valid = []
  for i in files
    if i.length > 0
      valid.push i
  new Session name, valid

Session.load = (name)->
  Util.ensureFile(@filePath(name), '\n').then =>
    Util.readFile(@filePath(name), 'utf8').then (data)->
      Session.parse(name, data)

Session.save = (name, files)->
  data = files.join('\n') + '\n'
  Util.writeFile @filePath(name), data, 'utf8'

Session.filePath = (name)-> ".labrat/#{name}.session"

module.exports = Session
