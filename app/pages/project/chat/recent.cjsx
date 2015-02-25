React = require 'react'
stingyFirebase = require '../../../lib/stingy-firebase'
FirebaseList = require '../../../components/firebase-list'
Comment = require './comment'

module.exports = React.createClass
  displayName: 'ProjectChatRecent'

  mixins: [stingyFirebase.Mixin]

  getDefaultProps: ->
    howMany: 25

  getInitialState: ->
    comments: []

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="content-container">
      <FirebaseList items={commentsRef.limitToLast @props.howMany}>{(key, comment) =>
        unless comment.flagged
          <Comment key={key} comment={comment} reference={commentsRef.child key} />
      }</FirebaseList>
    </div>
