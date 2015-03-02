React = require 'react'
TitleMixin = require '../../lib/title-mixin'
FirebaseComments = require '../../components/firebase-comments'

module.exports = React.createClass
  displayName: 'ProjectTalkPage'

  mixins: [TitleMixin]

  title: 'Project discussion'

  render: ->
    <div className="project-text-content content-container">
      <h1>General talk about this project</h1>
      <FirebaseComments type="project" id={@props.project.id} />
    </div>
