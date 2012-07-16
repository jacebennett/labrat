Util = require './util'
Session = require './session'
Config = require './config'
Runner = require './runner'

class Rat
  init: ->
    Util.ensureFolder ".labrat"

  add: (filename)->
    @loadEnv().spread (session)->
      session.add filename

  remove: (filename)->
    @loadEnv().spread (session)->
      session.remove filename

  clear: ->
    @loadEnv().spread (session)->
      session.reset()

  selectSession: (sessionName)->
    Config.load().then (config)->
      config.selectSession(sessionName)

  run: ->
    @loadEnv().spread (session, config)->
      new Runner(config).run session

  debug: ->
    @loadEnv().spread (session, config)->
      new Runner(config).debug session

  loadEnv: ->
    Config.load()
      .then (config)->
        sname = config.session
        Session.load(sname)
          .then (session)->
            [session, config]
          .fail (reason)->
            console.log "unable to load session #{sname}: #{reason}"
      .fail (reason)->
        console.log "unable to load config: #{reason}"

module.exports = Rat
