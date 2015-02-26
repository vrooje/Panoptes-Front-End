React = require 'react'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
{Link} = require 'react-router'

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
        <div key={key}>
          <Link to="project-chat-thread" params={linkParams}>{thread.name}</Link>
        </div>
      }</FirebaseList>

      <form onSubmit={@handleSubmit}>
        Create a new thread<br />
        <input name="new-thread-name" /><br />
        <textarea name="first-comment-content" /><br />
        <button type="submit">Create</button>
      </form>
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
