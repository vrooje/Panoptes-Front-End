React = require 'react'
stingyFirebase = require '../../lib/stingy-firebase'
Markdown = require '../../components/markdown'
HandlePropChanges = require '../../lib/handle-prop-changes'
PromiseToSetState = require '../../lib/promise-to-set-state'
PromiseRenderer = require '../../components/promise-renderer'
{Link} = require 'react-router'

module.exports = React.createClass
  displayName: 'ProjectHomePage'

  mixins: [stingyFirebase.Mixin, HandlePropChanges, PromiseToSetState]

  propChangeHandlers:
    project: (project) ->
      # TODO: Build this kind of caching into json-api-client.
      if project._workflows?
        @setState workflows: project._workflows
      else
        workflows = project.get 'workflows'

        workflows.then (workflows) =>
          project._workflows = workflows

        @promiseToSetState {workflows}

  getInitialState: ->
    workflows: []
    classificationsCount: 0
    volunteersCount: 0

  componentDidMount: ->
    @bindAsObject stingyFirebase.child("projects/#{@props.project.id}/classifications-count"), 'classificationsCount'
    @bindAsObject stingyFirebase.child("projects/#{@props.project.id}/volunteers-count"), 'volunteersCount'

  render: ->
    linkParams =
      owner: @props.owner.display_name
      name: @props.project.display_name

    <div className="project-home-page">
      <div className="call-to-action-container content-container">
        <Markdown className="description">{@props.project.description}</Markdown>
        <div className="stats">
          So far <strong>{@state.classificationsCount}</strong> classifications
          have been contributed by <strong>{@state.volunteersCount}</strong> volunteers.
        </div>

        {for workflow in @state.workflows
          <Link to="project-classify" params={linkParams} query={workflow: workflow.id} key={workflow.id} className="call-to-action standard-button">
            {workflow.display_name}
          </Link>}
      </div>

      <hr />

      <Markdown className="introduction content-container">{@props.project.introduction}</Markdown>
    </div>
