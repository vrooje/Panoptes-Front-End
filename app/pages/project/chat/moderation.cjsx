React = require 'react'
stingyFirebase = require '../../../lib/stingy-firebase'
FirebaseList = require '../../../components/firebase-list'
Comment = require './comment'

commentsRef = stingyFirebase.child 'comments'

module.exports = React.createClass
  displayName: 'ProjectChatModeration'

  render: ->
    <div className="content-container">
      <FirebaseList items={commentsRef.orderByChild('flagged').equalTo true}>{(key, comment) =>
        <div key={key}>
          <Comment comment={comment} reference={commentsRef.child key} />
          <button type="button" onClick={@handleUnflag.bind this, key}>Unflag</button>
          <button type="button" onClick={@handleDelete.bind this, key}>Delete</button>
          <hr />
        </div>
      }</FirebaseList>
    </div>

  handleUnflag: (key) ->
    commentsRef.child("#{key}/flagged").set false

  handleDelete: (key, e) ->
    if e.shiftKey or confirm 'Really delete this comment?'
      commentsRef.child(key).remove()
