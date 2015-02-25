React = require 'react'
{Link, RouteHandler} = require 'react-router'

module.exports = React.createClass
  displayName: 'ProjectChatIndex'

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
        <Link to="project-chat-moderation" params={linkParams} className="tabbed-content-tab">Moderation</Link>
      </nav>

      <RouteHandler {...@props} />
    </div>
