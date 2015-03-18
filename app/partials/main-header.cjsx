counterpart = require 'counterpart'
React = require 'react'
{Link} = require 'react-router'
ZooniverseLogo = require './zooniverse-logo'
Translate = require 'react-translate-component'
LoadingIndicator = require '../components/loading-indicator'
AccountBar = require './account-bar'
LoginBar = require './login-bar'
PromiseToSetState = require '../lib/promise-to-set-state'
auth = require '../api/auth'
{stargazing} = require '../api/config'

counterpart.registerTranslations 'en',
  mainNav:
    home: 'Home'
    about: 'About'
    projects: 'Projects'
    discuss: 'Discuss'
    lab: 'The lab'

module.exports = React.createClass
  displayName: 'MainHeader'

  mixins: [PromiseToSetState]

  getInitialState: ->
    user: null

  componentDidMount: ->
    @handleAuthChange()
    auth.listen @handleAuthChange

  componentWillUnmount: ->
    auth.stopListening @handleAuthChange

  handleAuthChange: ->
    @promiseToSetState user: auth.checkCurrent()

  render: ->
    <header className="main-header">
      <div className="main-title">
        <a href="https://www.zooniverse.org/" className="main-logo">
          <ZooniverseLogo /> Zooniverse
        </a>

        {if @state.user?
          <AccountBar user={@state.user} />
        else
          <LoginBar />}
      </div>

      {unless stargazing
        <nav className="main-nav">
          <Link to="about" className="main-nav-item"><Translate content="mainNav.about" /></Link>
          <Link to="projects" className="main-nav-item"><Translate content="mainNav.projects" /></Link>
          <a className="main-nav-item"><Translate content="mainNav.discuss" /></a>
          <hr />
          {if @state.user? and not stargazing
            <Link to="build" className="main-nav-item"><Translate className="minor" content="mainNav.lab" /></Link>}
        </nav>}

      <div className="main-header-group"></div>
    </header>
