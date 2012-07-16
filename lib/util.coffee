fs = require 'fs'
Q = require 'q'
Handlebars = require 'handlebars'
extend = require 'xtend'

Util =
  ensureFolder: (name)->
    try
      fs.mkdirSync(name)
    catch e
      throw e unless /EEXIST/.test(e.message)
  ensureFile: (name, defaultContent)->
    deferred = Q.defer()
    fs.exists name, (exists)=>
      unless exists
        @writeFile(name, defaultContent || '', 'utf-8').then ->
          deferred.resolve true
      else
        deferred.resolve false
    deferred.promise

  fileExists: Q.nbind(fs.exists)
  readFile: Q.nbind(fs.readFile)
  writeFile: Q.nbind(fs.writeFile)
  promise: Q.fcall
  template: (template)->
    Handlebars.compile template
  substitute: (template, data)->
    tmpl = @template template
    tmpl(data)

  extend: extend

  shellExec: (cmd)->
    Q.fcall -> console.log "would have executed '#{cmd}'"

module.exports = Util
