Util = require './util'
Session = require './session'
Config = require './config'
Runner = require './runner'

class Rat
  init: ->
    Util.ensureFolder ".labrat"

  add: (filename)->
    @withSession (session)->
      session.add filename

  remove: (filename)->
    @withSession (session)->
      session.remove filename

  clear: ->
    @withSession (session)->
      session.reset()

  selectSession: (sessionName)->
    debugger
    @withConfig (config)->
      debugger
      config.selectSession(sessionName)

  run: ->
    @withSession (session, config)->
      new Runner(config).run session

  debug: ->
    @withSession (session, config)->
      new Runner(config).debug session

  withConfig: (action)->
    Config.load()
      .then(action)
      .fail(@handleError)

  withSession: (action)->
    @withConfig (config)=>
      Session.load(config.session)
        .then (session)->
          [session, config]
        .spread(action)

  handleError: (error)->
    console.log "unexpected error: #{error}"

module.exports = Rat
