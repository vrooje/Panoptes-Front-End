React = require 'react'
apiClient = require '../../api/client'
{Navigation} = require 'react-router'
Loading = require '../../components/loading-indicator'
Select = require 'react-select'
debounce = require 'debounce'

module?.exports = React.createClass
  displayName: 'ProjectLinker'
  mixins: [Navigation]

  getInitialState: ->
    projects: []
    loading: true

  componentWillMount: ->
    @setProjects()

  goToProjectTalk: (projectId) ->
    apiClient.type('projects').get(projectId.toString()).then (project) =>
      project.get('owner').then (owner) =>
        @transitionTo 'project-talk', 
          owner: owner.slug
          name: project.slug

  setProjects: (metadata) ->
    apiClient.type('projects').get()
      .then (projects) =>
        @setState {projects, loading: false}

  onChangeSelect: (e) ->
    projectsSelect = React.findDOMNode(@).querySelector('select')
    projectId = projectsSelect.options[projectsSelect.selectedIndex].value
    @goToProjectTalk(projectId)

  projectOption: (d, i) ->
    <option key={d.id} value={d.id}>
      {d.display_name}
    </option>

  getProjects: (value, callback) ->
    apiClient.type('projects').get({display_name: value})
      .then (projects) =>
        options = projects.map (project) =>
          {value: project.id, label: project.display_name}
        callback null, {options}

  render: ->
    if @state.loading
      <Loading />

    else if @state.projects.length
      <div className="project-linker">
        <select onChange={@onChangeSelect}>
          {@state.projects.map(@projectOption)}
        </select>

        <Select
          name="project-linker"
          placeholder="Jump to a project"
          searchPromptText="Type the name of a project"
          className="project-linker-select"
          asyncOptions={debounce(@getProjects, 200)} />
      </div>

    else
      <p>Error retreiving projects list.</p>
