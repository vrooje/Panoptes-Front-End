React = require 'react'

module.exports = React.createClass
  displayName: 'ProjectChatHelp'

  render: ->
    <div className="content-container">
      ('threads').orderByChild('board').equalTo(BOARD_ID)
      Then manually sort them by timestamp.
    </div>

  handleSubmit: (e) ->
    e.preventDefault()
    "Push to /threads with board ID, get thread ID"
    "Push comment with thread ID to /comments"
