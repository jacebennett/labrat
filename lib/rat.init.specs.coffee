sinon = require 'sinon'
chai = require 'chai'
sinonChai = require 'sinon-chai'
chai.use sinonChai
expect = chai.expect
fs = require 'fs'
Q = require 'q'
Rat = require './rat'
Session = require './session'

describe 'Initialize Labrat Project', ->
  beforeEach ->
    @createFolderSpy = sinon.spy(fs, "mkdirSync")
    @rat = new Rat()
    @rat.init()

  afterEach ->
    fs.mkdirSync.restore()

  it 'should initialize a .labrat folder', ->
    expect(@createFolderSpy).to.have.been.calledWith ".labrat"

describe 'Adding a file', ->
  beforeEach (done)->
    @session =
      add: sinon.spy()

    deferred = Q.defer()

    deferred.resolve(@session)
    @loadSessionSpy = sinon.stub(Session, "load")
    @loadSessionSpy.returns deferred.promise

    @rat = new Rat()
    @rat.add('path/to/spec/file').then -> done()

  afterEach ->
    Session.load.restore()

  it 'should append the file to the current session', ->
    expect(@loadSessionSpy).to.have.been.calledWith "default"
    expect(@session.add).to.have.been.calledWith "path/to/spec/file"
