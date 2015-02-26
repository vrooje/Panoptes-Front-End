React = require 'react'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
{Link} = require 'react-router'
PromiseRenderer = require '../../../components/promise-renderer'
apiClient = require '../../../api/client'
moment = require 'moment'
ChangeListener = require '../../../components/change-listener'
auth = require '../../../api/auth'

module.exports = React.createClass
  displayName: 'ProjectChatHelp'

  render: ->
    defaultLinkParams =
      owner: @props.owner.display_name
      name: @props.project.display_name
      boardID: @props.params.boardID

    <div className="content-container">
      <FirebaseList ref="threadsList" items={stingyFirebase.child("projects/#{@props.project.id}/threads").orderByChild('board').equalTo(@props.params.boardID)}>{(key, thread) =>
        linkParams = Object.create defaultLinkParams
        linkParams.threadID = key
        <p key={key}>
          <Link to="project-chat-thread" params={linkParams} className="secret-button">
            <span className="minor-button">{thread.name}</span>{' '}
            Started by <PromiseRenderer tag="span" promise={apiClient.type('users').get thread.user} then="display_name"/>{' '}
            <time title={moment(thread.timestamp).format 'llll'}>{moment(thread.timestamp).fromNow()}</time>
          </Link>
        </p>
      }</FirebaseList>

      <hr />

      <ChangeListener target={auth}>{=>
        <PromiseRenderer promise={auth.checkCurrent()}>{(user) =>
          if user?
            <div>
              <p><strong>Create a new thread</strong></p>
              <form onSubmit={@handleSubmit}>
                <input name="new-thread-name" className="standard-input full" placeholder="Thread title" /><br />
                <textarea name="first-comment-content" className="standard-input full" placeholder="First comment" /><br />
                <button type="submit" className="standard-button">Create</button>
              </form>
            </div>
          else
            <p><strong>Sign in start a thread</strong></p>
        }</PromiseRenderer>
      }</ChangeListener>
    </div>

  handleSubmit: (e) ->
    e.preventDefault()

    domNode = @getDOMNode()
    threadNameInput = domNode.querySelector '[name="new-thread-name"]'
    commentContentInput = domNode.querySelector '[name="first-comment-content"]'

    threadRef = stingyFirebase.child("projects/#{@props.project.id}/threads").push
      board: @props.params.boardID
      name: threadNameInput.value
      user: stingyFirebase.getAuth().uid
      timestamp: Firebase.ServerValue.TIMESTAMP
      count: 1

    stingyFirebase.child("projects/#{@props.project.id}/comments").push
      thread: threadRef.key()
      content: commentContentInput.value
      user: stingyFirebase.getAuth().uid
      timestamp: Firebase.ServerValue.TIMESTAMP

    threadNameInput.value = ''
    commentContentInput.value = ''
    @refs.threadsList.displayAll()
