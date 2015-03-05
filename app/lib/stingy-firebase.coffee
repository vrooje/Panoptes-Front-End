auth = require '../api/auth'
Firebase = require 'firebase'
ReactFire = require 'reactfire'

DISCONNECT_DELAY = 2000

root = new Firebase "https://panoptes-comments.firebaseio.com/#{location.host.replace /\W+/g, '-'}"

auth.listen ->
  auth.checkCurrent().then (user) ->
    if user?
      root.authWithCustomToken user.firebase_auth_token, (error, authData) ->
    else
      root.unauth()

connections = 0
disconnectTimeout = NaN

connect = ->
  unless isNaN disconnectTimeout
    clearTimeout disconnectTimeout
  connections += 1
  if connections is 1
    console?.log 'Connecting to Firebase!'
    Firebase.goOnline()

reallyDisconnect = ->
  console?.log 'Disconnecting from Firebase!'
  Firebase.goOffline()
  disconnectTimeout = NaN

disconnect = ->
  connections -= 1
  if connections is 0
    unless isNaN disconnectTimeout
      clearTimeout disconnectTimeout
    disconnectTimeout = setTimeout reallyDisconnect, DISCONNECT_DELAY

Firebase.goOffline() # Start offline.

module.exports =
  root: root

  child: root.child.bind root

  getAuth: root.getAuth.bind root

  increment: (path) ->
    connect()
    root.child(path).transaction (count) ->
      disconnect()
      count ?= 0
      count + 1

  Mixin:
    mixins: [ReactFire]

    componentDidMount: ->
      connect()

    componentWillUnmount: ->
      disconnect()
