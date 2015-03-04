React = require 'react'
Markdown = require '../../components/markdown'
HandlePropChanges = require '../../lib/handle-prop-changes'
PromiseToSetState = require '../../lib/promise-to-set-state'
PromiseRenderer = require '../../components/promise-renderer'
{Link} = require 'react-router'
ProgressWheel = require '../../components/progress-wheel'

getWorkflowCompleteness = (workflow) ->
  total = 0
  retired = 0
  workflow.get('subject_sets').then (subjectSets) ->
    for subjectSet in subjectSets
      total += subjectSet.set_member_subjects_count
      retired += subjectSet.retired_set_member_subjects_count
    retired / total

getProjectCompleteness = (project) ->
  total = 0
  retired = 0
  project.get('workflows').then (workflows) ->
    workflowCounts = for workflow in workflows
      workflow.get('subject_sets').then (subjectSets) ->
        for subjectSet in subjectSets
          total += subjectSet.set_member_subjects_count
          retired += subjectSet.retired_set_member_subjects_count
        retired / total
    Promise.all(workflowCounts).then ->
      retired / total

module.exports = React.createClass
  displayName: 'ProjectHomePage'

  mixins: [HandlePropChanges, PromiseToSetState]

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

  render: ->
    linkParams =
      owner: @props.owner.display_name
      name: @props.project.display_name

    <div className="project-home-page">
      <div className="call-to-action-container content-container">
        <Markdown className="description">{@props.project.description}</Markdown>

        {for workflow in @state.workflows
          <span key={workflow.id}>
            <Link to="project-classify" params={linkParams} query={workflow: workflow.id} className="call-to-action standard-button">
              {workflow.display_name}
            </Link>{' '}
            <PromiseRenderer tag="span" promise={getWorkflowCompleteness workflow}>{(completeness) =>
              <ProgressWheel value={completeness} title="#{Math.floor completeness * 100}% complete" />
            }</PromiseRenderer>
          </span>}

          <PromiseRenderer promise={getProjectCompleteness @props.project}>{(completeness) =>
            <p className="form-help">Project: {Math.floor completeness * 100}% complete <ProgressWheel value={completeness} /></p>
          }</PromiseRenderer>
      </div>

      <hr />

      <Markdown className="introduction content-container">{@props.project.introduction}</Markdown>
    </div>
