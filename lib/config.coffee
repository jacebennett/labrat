Util = require './util'

cached = null
defaults =
  session: 'default',
  bootstrap: 'labrat.env.js',
  manifest: '.labrat.manifest.js',
  manifestTemplate: 'require("{{file}}");'
  buildCmd: 'coffee -c **/*.coffee'
  runCmd: 'mocha -R specs {{files}}'
  debugCmd: 'mocha debug {{files}}'

class Config
  constructor: (@json)->
    Util.extend(this, defaults, @json)
  selectSession: (session)->
    @session = @json.session = session
    @save()
  save: ->
    Config.save(@json)

Config.load = ->
  if cached?
    Util.promise -> cached
  else
    Util.ensureFile(@filePath(), '{}').then (result)=>
      Util.readFile(@filePath(), 'utf-8').then (strData)->
        json = JSON.parse strData
        cached = new Config json

Config.save = (json)->
  Util.writefile @filePath(), JSON.stringify(json), 'utf-8'

Config.filePath = -> "labrat.json"

module.exports = Config
