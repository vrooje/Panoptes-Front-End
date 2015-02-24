auth = require '../api/auth'
Firebase = require 'firebase'
ReactFire = require 'reactfire'

DISCONNECT_DELAY = 2000

root = new Firebase 'https://panoptes-comments.firebaseio.com'

auth.listen ->
  auth.checkCurrent().then (user) ->
    if user?
      root.authAnonymously (error, authData) ->
        root.child('users').child(authData.uid).set user.id
    else
      root.unauth()

connections = 0
disconnectTimeout = NaN

connect = ->
  unless isNaN disconnectTimeout
    clearTimeout disconnectTimeout
  connections += 1
  if connections is 1
    console.log 'Connecting to Firebase!'
    Firebase.goOnline()

reallyDisconnect = ->
  console.log 'Disconnecting from Firebase!'
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
  child: root.child.bind root

  getAuth: root.getAuth.bind root

  Mixin:
    mixins: [ReactFire]

    componentDidMount: ->
      connect()

    componentWillUnmount: ->
      disconnect()
