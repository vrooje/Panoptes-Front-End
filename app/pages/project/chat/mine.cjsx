React = require 'react'

module.exports = React.createClass
  displayName: 'ProjectChatMine'

  render: ->
    <div className="content-container">
      ('comments').orderByChild('author').equalTo(FIREBASE_UATH_UID)
    </div>
