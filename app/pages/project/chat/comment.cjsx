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
      {unless @props.summary
        <div className="controls">
          {unless @props.comment.flagged
            <ChangeListener target={auth}>{=>
              <PromiseRenderer promise={auth.checkCurrent()}>{(user) =>
                if user?
                  <button type="button" className="secret-button" onClick={@handleFlag}><i className="fa fa-flag fa-fw"></i> Report</button>
              }</PromiseRenderer>
            }</ChangeListener>}
        </div>}

      <PromiseRenderer promise={apiClient.type('users').get(@props.comment.user)}>{(user) =>
        <div className="byline">
          <img src={user.avatar} style={borderRadius: '50%', height: '1.5em', verticalAlign: 'middle', width: '1.5em'} />&nbsp;
          <span>{user.display_name}</span>{' '}
          <time className="timestamp" title={moment(@props.comment.timestamp).format 'llll'}>{moment(@props.comment.timestamp).fromNow()}</time>
        </div>
      }</PromiseRenderer>

      {if @props.summary
        <div className="content">{@props.comment.content}</div>
      else
        <Markdown className="content">{@props.comment.content}</Markdown>}
    </div>

  handleFlag: ->
    if confirm 'Really flag this comment?'
      @props.reference.child('flagged').set true
