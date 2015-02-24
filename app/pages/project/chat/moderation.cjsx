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
        <div>
          <Comment key={key} comment={comment} reference={commentsRef.child key} />
          <button type="button" onClick={@handleUnflag}>Unflag</button>
          <button type="button" onClick={@handleDelete}>Delete</button>
          <hr />
        </div>
      }</FirebaseList>
    </div>

  handleUnflag: ->
    @props.reference.child('flagged').set false

  handleDelete: (e) ->
    if e.shiftKey or confirm 'Really delete this comment?'
      @props.reference.remove()
