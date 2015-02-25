React = require 'react'
stingyFirebase = require '../../../lib/stingy-firebase'
FirebaseList = require '../../../components/firebase-list'
Comment = require './comment'

module.exports = React.createClass
  displayName: 'ProjectChatMine'

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="content-container">
      <FirebaseList ref="commentsList" items={commentsRef.orderByChild('user').equalTo(stingyFirebase.getAuth().uid)}>{(key, comment) =>
        <Comment key={key} comment={comment} reference={commentsRef.child key} />
      }</FirebaseList>
    </div>
