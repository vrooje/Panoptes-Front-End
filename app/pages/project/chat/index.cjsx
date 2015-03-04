React = require 'react'
Router = {Link, RouteHandler} = require 'react-router'
stingyFirebase = require '../../../lib/stingy-firebase'
ChangeListener = require '../../../components/change-listener'
auth = require '../../../api/auth'
PromiseRenderer = require '../../../components/promise-renderer'

module.exports = React.createClass
  displayName: 'ProjectChatIndex'

  mixins: [Router.Navigation, stingyFirebase.Mixin]

  getInitialState: ->
    mods: null

  componentDidMount: ->
    @bindAsObject stingyFirebase.child("projects/#{@props.project.id}/mods"), 'mods'

  render: ->
    linkParams =
      owner: @props.owner.display_name
      name: @props.project.display_name

    helpBoardParams = Object.create linkParams
    helpBoardParams.boardID = 'help'

    <div>
      <nav className="tabbed-content-tabs">
        <Link to="project-chat-recent" params={linkParams} className="tabbed-content-tab">Recent</Link>
        <Link to="project-chat-popular" params={linkParams} className="tabbed-content-tab">Popular</Link>
        <Link to="project-chat-mine" params={linkParams} className="tabbed-content-tab">Mine</Link>
        <Link to="project-chat-board" params={helpBoardParams} className="tabbed-content-tab">Help</Link>
        <ChangeListener target={auth}>{=>
          <PromiseRenderer promise={auth.checkCurrent()}>{(user) =>
            if @state.mods? and user?.id of @state.mods
              <Link to="project-chat-moderation" params={linkParams} className="tabbed-content-tab">Moderation</Link>
          }</PromiseRenderer>
        }</ChangeListener>

        <form style={display: 'inline-block'} onSubmit={@handleSubmit}>
          <input ref="searchInput" type="search" defaultValue={@props.query?.q} />{' '}
          <button type="submit" className="secret-button"><i className="fa fa-search fa-fw"></i></button>
        </form>
      </nav>

      <RouteHandler {...@props} />
    </div>

  handleSubmit: (e) ->
    e.preventDefault()
    @transitionTo 'project-chat-search', @props.params, q: encodeURIComponent @refs.searchInput.getDOMNode().value
