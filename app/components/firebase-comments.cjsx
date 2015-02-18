React = require 'react'
ReactFire = require 'reactfire'
Firebase = require 'firebase'
PromiseRenderer = require './promise-renderer'
Markdown = require './markdown'
MarkdownEditor = require './markdown-editor'
ChangeListener = require './change-listener'
auth = require '../api/auth'
apiClient = require '../api/client'

firebaseRoot = new Firebase 'https://panoptes-comments.firebaseio.com'
usersRoot = firebaseRoot.child 'users'
commentsRoot = firebaseRoot.child 'comments'

Comment = React.createClass
  mixins: [ReactFire]

  getInitialState: ->
    userID: ''

  componentDidMount: ->
    @bindAsObject usersRoot.child(@props.comment.user), 'userID'

  render: ->
    <div className="comment">
      {if @state.userID
        <PromiseRenderer promise={apiClient.type('users').get(@state.userID)}>{(user) =>
          <div className="byline">
            <img src={user.avatar} style={borderRadius: '50%', height: '1.5em', verticalAlign: 'middle', width: '1.5em'} />&nbsp;
            <strong>{user.display_name}</strong> at {(new Date @props.comment.timestamp).toString()}
          </div>
        }</PromiseRenderer>}
      <Markdown>{@props.comment.content}</Markdown>
    </div>

CommentField = React.createClass
  getDefaultProps: ->
    onSubmit: Function.prototype

  render: ->
    <PromiseRenderer promise={auth.checkCurrent()}>{(user) =>
      if user?
        <form className="comment-field" onSubmit={@handleSubmit}>
          <textarea name="content-input" rows="8" className="standard-input full" /><br />
          <button type="submit" className="standard-button">Post</button>
        </form>
      else
        <p>You must be signed in to comment.</p>
    }</PromiseRenderer>

  handleSubmit: (e) ->
    e.preventDefault()
    contentInput = @getDOMNode().querySelector '[name="content-input"]'

    payload =
      timestamp: Firebase.ServerValue.TIMESTAMP
      user: firebaseRoot.getAuth()?.uid
      content: contentInput.value

    payload[@props.type] = @props.id

    commentsRoot.push payload, =>
      contentInput.value = ''
      @props.onSubmit? e

CommentsArea = React.createClass
  mixins: [ReactFire]

  getInitialState: ->
    comments: []
    displayCount: -1

  componentDidMount: ->
    @bindAsArray commentsRoot.orderByChild(@props.type).equalTo(@props.id).limitToLast(100), 'comments'

  componentWillUpdate: (nextProps, nextState) ->
    if @state.displayCount is -1
      nextState.displayCount = nextState.comments.length

  render: ->
    <div className="firebase-comments">
      {for comment in @state.comments[0...@state.displayCount]
        <Comment key={comment.user + comment.timestamp} comment={comment} />}

      {if @state.comments.length > @state.displayCount
        <p>
          <button type="button" className="minor-button" onClick={@displayAll}>Load {@state.comments.length - @state.displayCount} more</button>
        </p>}

      {if @state.comments.length is 0
        <p>Be the first to comment!</p>
      else
        <p>Leave a comment</p>}
      <CommentField type={@props.type} id={@props.id} onSubmit={@displayAll} />
    </div>

  displayAll: ->
    @setState displayCount: @state.comments.length

module.exports = React.createClass
  getDefaultProps: ->
    type: ''
    id: ''

  componentDidMount: ->
    Firebase.goOnline()
    auth.listen @handleAuthChange
    @handleAuthChange()

  componentWillUnmount: ->
    auth.stopListening @handleAuthChange
    Firebase.goOffline()

  handleAuthChange: ->
    auth.checkCurrent().then (user) ->
      if user?
        firebaseRoot.authAnonymously (error, authData) ->
          firebaseRoot.child('users').child(authData.uid).set user.id
      else
        firebaseRoot.unauth()

  render: ->
    <CommentsArea type={@props.type} id={@props.id} />
