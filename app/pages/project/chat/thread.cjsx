React = require 'react'

module.exports = React.createClass
  displayName: 'ProjectChatHelp'

  render: ->
    <div className="content-container">
      ('comments').orderByChild('thread').equalTo(THREAD_ID)
    </div>

  handleSubmit: (e) ->
    e.preventDefault()
    "Push comment to /comments with thread ID"
