Util = require './util'

class Runner
  constructor: (@config)->
  run: (session)->
    @writeManifest(session)
      .then =>
        @build()
      .then =>
        cmdline = Util.substitute @config.runCmd,
          files: "#{@config.bootstrap} #{@config.manifest}"
        Util.shellExec cmdline

  debug: (session)->
    @writeManifest(session)
      .then =>
        @build()
      .then =>
        cmdline = Util.substitute @config.debugCmd,
          files: "#{@config.bootstrap} #{@config.manifest}"
        Util.shellExec cmdline

  writeManifest: (session)->
    tmpl = Util.template @config.manifestTemplate
    lines = []
    lines.push(tmpl({file: i})) for i in session.files
    manifestStr = lines.join('\n') + '\n'
    Util.writeFile @config.manifest, manifestStr, 'utf8'

  build: ->
    Util.shellExec @config.buildCmd

module.exports = Runner
