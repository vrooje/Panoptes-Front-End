React = require 'react'
ReactFire = require 'reactfire'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
Comment = require './comment'
ChangeListener = require '../../../components/change-listener'
auth = require '../../../api/auth'
PromiseRenderer = require '../../../components/promise-renderer'

module.exports = React.createClass
  displayName: 'ProjectChatHelp'

  mixins: [ReactFire]

  getInitialState: ->
    thread: null

  componentDidMount: ->
    @bindAsObject stingyFirebase.child("projects/#{@props.project.id}/threads/#{@props.params.threadID}"), 'thread'

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="content-container">
      {if @state.thread?
        <p><strong>{@state.thread.name}</strong> ({@state.thread.count} comments)</p>}

      <FirebaseList ref="commentsList" items={commentsRef.orderByChild('thread').equalTo(@props.params.threadID)}>{(key, comment) =>
        <Comment key={key} comment={comment} reference={commentsRef.child key} />
      }</FirebaseList>

      <hr />

      <ChangeListener target={auth}>{=>
        <PromiseRenderer promise={auth.checkCurrent()}>{(user) =>
          if user?
            <div>
              <p><strong>Leave a comment</strong></p>
              <form onSubmit={@handleSubmit}>
                <textarea name="comment-content" className="standard-input full" /><br />
                <button type="submit" className="standard-button">Save comment</button>
              </form>
            </div>
          else
            <p><strong>Sign in leave a comment</strong></p>
        }</PromiseRenderer>
      }</ChangeListener>
    </div>

  handleSubmit: (e) ->
    e.preventDefault()

    commentContentInput = @getDOMNode().querySelector('[name="comment-content"]')

    stingyFirebase.child("projects/#{@props.project.id}/comments").push
      thread: @props.params.threadID
      content: commentContentInput.value
      user: stingyFirebase.getAuth().uid
      timestamp: Firebase.ServerValue.TIMESTAMP

    stingyFirebase.child("projects/#{@props.project.id}/threads/#{@props.params.threadID}/last-update").set Firebase.ServerValue.TIMESTAMP
    stingyFirebase.increment "projects/#{@props.project.id}/threads/#{@props.params.threadID}/count"

    commentContentInput.value = ''
    @refs.commentsList.displayAll()
