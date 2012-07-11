fs = require 'fs'
Session = require './session'

ensureFolder = (name)->
  try
    fs.mkdirSync(name)
  catch e
    throw e unless /EEXIST/.test(e.message)

class Rat
  init: ->
    ensureFolder ".labrat"

  add: (name)->
    @currentSession (session)->
      session.add name

  currentSession: (callback)->
    if @config().currentSession?
      @loadSession(@config().currentSession, callback)
    else
      @loadSession("default", callback)

  loadSession: (name, callback)->
    sessionPath = ".labrat/" + sessionName + ".session"
    fs.readFile sessionPath, (contents)->
      callback Session.parse(contents)

  config: ->
    {}

module.exports = Rat
