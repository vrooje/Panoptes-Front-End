React = require 'react'
stingyFirebase = require '../../../lib/stingy-firebase'
FirebaseList = require '../../../components/firebase-list'
{Link} = require 'react-router'
Comment = require './comment'

module.exports = React.createClass
  displayName: 'ProjectChatMine'

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="content-container">
      {if stingyFirebase.getAuth()?
        <FirebaseList items={commentsRef.orderByChild('user').equalTo(stingyFirebase.getAuth().uid)} reverse>{(key, comment) =>
          linkParams = Object.create @props.params
          linkParams.subjectID = comment.subject
          linkParams.threadID = comment.thread

          linkTo = if 'subject' of comment
            'subject-details'
          else if 'thread' of comment
            'project-chat-thread'

          <Link to={linkTo} params={linkParams} className="secret-button full">
            <Comment key={key} comment={comment} reference={commentsRef.child key} summary />
          </Link>
        }</FirebaseList>
      else
        <p>You’re not signed in.</p>}
    </div>
