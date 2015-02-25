React = require 'react'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'

module.exports = React.createClass
  displayName: 'ProjectChatHelp'

  render: ->
    <div className="content-container">
      <FirebaseList ref="commentsList" items={stingyFirebase.child("projects/#{@props.project.id}/comments").orderByChild('thread').equalTo(@props.params.threadID)}>{(key, comment) =>
        <div key={key}>
          {comment.content}
        </div>
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

    commentContentInput.value = ''
    @refs.commentsList.displayAll()
