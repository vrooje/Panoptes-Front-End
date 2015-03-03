React = require 'react'
TitleMixin = require '../../lib/title-mixin'

module.exports = React.createClass
  displayName: 'ProjectTalkPage'

  mixins: [TitleMixin]

  title: 'Project discussion'

  render: ->
    <div className="project-text-content content-container">
      <h1>General talk about this project</h1>
    </div>
