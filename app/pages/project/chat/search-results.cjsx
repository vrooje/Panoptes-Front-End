React = require 'react'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
Comment = require './comment'

module.exports = React.createClass
  displayName: 'ProjectChatSearchResults'

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="content-container">
      <p>TODO: Search for <code>{@props.query?.q}</code></p>
    </div>
