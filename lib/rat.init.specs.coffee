sinon = require 'sinon'
chai = require 'chai'
sinonChai = require 'sinon-chai'
chai.use sinonChai
expect = chai.expect
fs = require 'fs'
Rat = require './rat'

describe 'Initialize Labrat Project', ->
  beforeEach ->
    @originalMkdir = fs.mkdirSync
    @createFolderSpy = sinon.spy(fs, "mkdirSync")
    @rat = new Rat()
    @rat.init()

  afterEach ->
    fs.mkdirSync = @originalMkdir

  it 'should initialize a .labrat folder', ->
    expect(@createFolderSpy).to.have.been.calledWith ".labrat"

describe 'Adding a file', ->
  beforeEach ->
    @session =
      add: sinon.spy()
    @rat = new Rat()
    @loadSessionSpy = @rat.loadSession = sinon.spy((name, callback)=> callback(@session))
    @rat.add('path/to/spec/file')

  it 'should append the file to the current session', ->
    expect(@loadSessionSpy).to.have.been.calledWith "default"
    expect(@session.add).to.have.been.calledWith "path/to/spec/file"
