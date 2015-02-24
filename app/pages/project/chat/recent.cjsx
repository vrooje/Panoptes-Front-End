React = require 'react'
stingyFirebase = require '../../../lib/stingy-firebase'
FirebaseList = require '../../../components/firebase-list'
Comment = require './comment'

commentsRef = stingyFirebase.child 'comments'

module.exports = React.createClass
  displayName: 'ProjectChatRecent'

  mixins: [stingyFirebase.Mixin]

  getDefaultProps: ->
    howMany: 25

  getInitialState: ->
    comments: []

  render: ->
    <div className="content-container">
      <FirebaseList items={commentsRef.orderByChild('project').equalTo(@props.project.id).limitToLast @props.howMany}>{(key, comment) =>
        unless comment.flagged
          <Comment key={key} comment={comment} reference={commentsRef.child key} summary />
      }</FirebaseList>
    </div>
