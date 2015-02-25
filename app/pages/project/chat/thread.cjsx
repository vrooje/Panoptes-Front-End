React = require 'react'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
Comment = require './comment'

module.exports = React.createClass
  displayName: 'ProjectChatHelp'

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="content-container">
      <FirebaseList ref="commentsList" items={commentsRef.orderByChild('thread').equalTo(@props.params.threadID)}>{(key, comment, ref) =>
        <Comment key={key} comment={comment} reference={commentsRef.child key} />
      }</FirebaseList>

      <form onSubmit={@handleSubmit}>
        <textarea name="comment-content" /><br />
        <button type="submit">Comment</button>
      </form>
    </div>

  handleSubmit: (e) ->
    e.preventDefault()

    commentContentInput = @getDOMNode().querySelector('[name="comment-content"]')

    stingyFirebase.child("projects/#{@props.project.id}/comments").push
      thread: @props.params.threadID
      content: commentContentInput.value
      timestamp: Firebase.ServerValue.TIMESTAMP

    stingyFirebase.child("projects/#{@props.project.id}/threads/#{@props.params.threadID}/last-update").set Firebase.ServerValue.TIMESTAMP
    stingyFirebase.child("projects/#{@props.project.id}/threads/#{@props.params.threadID}/count").transaction (count) ->
      (count ? 0) + 1

    commentContentInput.value = ''
    @refs.commentsList.displayAll()
