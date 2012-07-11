class Session
  add: (name)->
    #do something

Session.parse = (data)->
  new Session

module.exports = Session
