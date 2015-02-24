React = require 'react'

HOW_MANY = 25

module.exports = React.createClass
  displayName: 'ProjectChatPopular'

  render: ->
    <div className="content-container">
      ('subjects').orderByChild('comments').limitToLast(HOW_MANY)
      Loop through keys
    </div>
