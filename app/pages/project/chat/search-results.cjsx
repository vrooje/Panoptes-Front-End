React = require 'react'
Router = require 'react-router'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
Comment = require './comment'

module.exports = React.createClass
  displayName: 'ProjectChatSearchResults'

  mixins: [Router.Navigation]

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="content-container">
      <form onSubmit={@handleSubmit}>
        <input ref="searchInput" type="search" defaultValue={@props.query?.q} />
        <button type="submit">Search</button>
      </form>
      <p>TODO: Search for <code>{@props.query?.q}</code></p>
    </div>

  handleSubmit: (e) ->
    e.preventDefault()
    @transitionTo 'project-chat-search', @props.params, q: encodeURIComponent @refs.searchInput.getDOMNode().value
