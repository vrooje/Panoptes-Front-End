{stargazing} = require './api/config'
React = require 'react'
window.React = React
Router = {RouteHandler, DefaultRoute, Route, NotFoundRoute} = require 'react-router'
redirect = require './pages/redirect'
MainHeader = require './partials/main-header'
MainFooter = require './partials/main-footer'

if stargazing
  console?.info 'This is what the site will look like during Stargazing Live.'

App = React.createClass
  displayName: 'PanoptesApp'

  render: ->
    <div className="panoptes-main">
      <MainHeader />
      <div className="main-content">
        <RouteHandler {...@props} />
      </div>
      <MainFooter />
    </div>

if stargazing
  ComingSoon = React.createClass
    displayName:'Coming soon'

    render: ->
      <div className="content-container">
        <i className="fa fa-calendar"></i> Coming soon
      </div>

routes = <Route handler={App}>
  <DefaultRoute name="home" handler={if stargazing then redirect 'project-home', owner: 'brian-testing', name: 'Supernovae' else require './pages/home'} />
  <Route name="about" handler={redirect 'https://www.zooniverse.org/about'} />

  <Route name="settings" handler={if stargazing then redirect 'https://www.zooniverse.org/account/settings' else require './pages/settings'} />
  <Route name="privacy" handler={if stargazing then redirect 'https://www.zooniverse.org/privacy' else require './pages/privacy-policy'} />

  <Route name="user-profile" path="users/:name" handler={if stargazing then redirect 'https://www.zooniverse.org/me' else require './pages/user-profile'} />

  <Route name="projects" handler={if stargazing then redirect 'https://www.zooniverse.org/projects' else require './pages/projects'} />
  <Route path="projects/:owner/:name" handler={require './pages/project'}>
    <DefaultRoute name="project-home" handler={require './pages/project/home'} />
    <Route name="project-science-case" path="science-case" handler={require './pages/project/science-case'} />
    <Route name="project-status" path="status" handler={require './pages/project/status'} />
    <Route name="project-team" path="team" handler={require './pages/project/team'} />
    <Route name="project-classify" path="classify" handler={require './pages/project/classify'} />
    <Route name="project-talk" path="talk" handler={require './pages/project/talk'} />
  </Route>

  <Route name="build" handler={if stargazing then ComingSoon else require './pages/build'} />}
  <Route name="new-project" path="build/new-project" handler={if stargazing then ComingSoon else require './pages/new-project'}>
    <DefaultRoute name="new-project-general" handler={if stargazing then ComingSoon else require './pages/new-project/general'} />
    <Route name="new-project-science-case" path="science-case" handler={if stargazing then ComingSoon else require './pages/new-project/science-case'} />
    <Route name="new-project-subjects" path="subjects" handler={if stargazing then ComingSoon else require './pages/new-project/subjects'} />
    <Route name="new-project-workflow" path="workflow" handler={if stargazing then ComingSoon else require './pages/new-project/workflow'} />
    <Route name="new-project-review" path="review" handler={if stargazing then ComingSoon else require './pages/new-project/review'} />
  </Route>}
  <Route name="edit-project" path="edit-project/:id" handler={if stargazing then ComingSoon else require './pages/edit-project'} />
  <Route name="edit-workflow" path="edit-workflow/:id" handler={if stargazing then ComingSoon else require './pages/edit-workflow'} />

  <Route path="todo/?*" handler={React.createClass render: -> <div className="content-container"><i className="fa fa-cogs"></i> TODO</div>} />
  <NotFoundRoute handler={React.createClass render: -> <div className="content-container"><i className="fa fa-frown-o"></i> Not found</div>} />

  <Route path="dev/workflow-tasks-editor" handler={require './components/workflow-tasks-editor'} />
  <Route path="dev/classifier" handler={require './classifier'} />
  <Route path="dev/aggregate" handler={require './components/aggregate-view'} />
</Route>

mainContainer = document.createElement 'div'
mainContainer.id = 'panoptes-main-container'
document.body.appendChild mainContainer

Router.run routes, (Handler, handlerProps) ->
  React.render(<Handler {...handlerProps} />, mainContainer);
