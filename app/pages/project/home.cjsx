React = require 'react'
stingyFirebase = require '../../lib/stingy-firebase'
Markdown = require '../../components/markdown'
HandlePropChanges = require '../../lib/handle-prop-changes'
PromiseToSetState = require '../../lib/promise-to-set-state'
PromiseRenderer = require '../../components/promise-renderer'
{Link} = require 'react-router'
ProgressWheel = require '../../components/progress-wheel'
grouper = require 'number-grouper'

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
      <div className="call-to-action content-container">
        <p className="description">{@props.project.description}</p>

        <div>
          {for workflow in @state.workflows
            <span key={workflow.id}>
              <Link to="project-classify" params={linkParams} query={workflow: workflow.id} className="standard-button">
                {workflow.display_name}
              </Link>&emsp;
            </span>}
        </div>
      </div>

      <div>
        <div className="project-stats">
          <div className="stat">
            <div className="label">Volunteers</div>
            <div className="value">{grouper @state.volunteersCount ? 0}</div>
          </div>
          <div className="stat">
            <div className="label">Classifications</div>
            <div className="value">{grouper @state.classificationsCount ? 0}</div>
          </div>
          <div className="stat">
            <div className="label">Total subjects</div>
            <div className="value">{grouper @props.project.subjects_count}</div>
          </div>
          <div className="stat">
            <div className="label">Subjects completed</div>
            <div className="value">{grouper @props.project.retired_subjects_count}</div>
          </div>
          <div className="stat">
            <div className="label">Project completion</div>
            <div className="value">{Math.round(@props.project.retired_subjects_count / @props.project.subjects_count * 100) || 0}%</div>
          </div>
        </div>

        <div className="introduction">
          <Markdown className="content-container">{@props.project.introduction}</Markdown>
        </div>
      </div>
    </div>
