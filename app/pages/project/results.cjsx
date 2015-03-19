React = require 'react'
TitleMixin = require '../../lib/title-mixin'
Markdown = require '../../components/markdown'

module.exports = React.createClass
  displayName: 'ProjectResultsPage'

  mixins: [TitleMixin]

  title: 'Results'

  render: ->
    <div className="project-text-content results-page content-container">
      <Markdown>{@props.project.result || 'This project has no results to report yet.'}</Markdown>
    </div>
