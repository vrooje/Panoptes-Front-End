stingyFirebase = require '../../../lib/stingy-firebase'
React = require 'react'
ChangeListener = require '../../../components/change-listener'
auth = require '../../../api/auth'
PromiseRenderer = require '../../../components/promise-renderer'
apiClient = require '../../../api/client'
moment = require 'moment'
Markdown = require '../../../components/markdown'

module.exports = React.createClass
  mixins: [stingyFirebase.Mixin]

  getDefaultProps: ->
    comment: null
    reference: null
    summary: false

  render: ->
    <div className="chat-comment" data-summary={@props.summary || null}>
      <PromiseRenderer promise={apiClient.type('users').get(@props.comment.user)}>{(user) =>
        <div className="byline">
          <p><img src={user.avatar} className="avatar" /></p>
          <p>{user.display_name}</p>
        </div>
      }</PromiseRenderer>

      <div className="body">
        <div className="metadata columns-container inline spread">
          <time className="timestamp" title={moment(@props.comment.timestamp).format 'llll'}>{moment(@props.comment.timestamp).fromNow()}</time>

          {unless @props.summary or @props.comment.flagged
            <ChangeListener target={auth}>{=>
              <PromiseRenderer promise={auth.checkCurrent()}>{(user) =>
                if user?
                  <button type="button" className="secret-button" onClick={@handleFlag}>Report</button>
              }</PromiseRenderer>
            }</ChangeListener>}
        </div>

        {if @props.summary
          <div className="content">{@props.comment.content}</div>
        else
          <Markdown className="content">{@props.comment.content}</Markdown>}
      </div>
    </div>

  handleFlag: ->
    if confirm 'Really flag this comment?'
      @props.reference.child('flagged').set true
