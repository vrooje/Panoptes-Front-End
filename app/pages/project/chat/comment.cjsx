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

  getInitialState: ->
    showFlagged: false

  render: ->
    <div className="chat-comment" data-flagged={@props.comment.flagged || null} data-summary={@props.summary || null}>
      <PromiseRenderer promise={apiClient.type('users').get(@props.comment.user)}>{(user) =>
        if @props.comment.flagged and not @state.showFlagged
          <div className="byline">
            <p className="form-help"><i className="fa fa-exclamation-triangle"></i></p>
            <p className="form-help">(Reported)</p>
          </div>
        else
          <div className="byline">
            <p><img src={user.avatar} className="avatar" /></p>
            <p>{user.display_name}</p>
          </div>
      }</PromiseRenderer>

      <div className="body">
        <div className="metadata columns-container inline spread">
          <span>
            <time className="timestamp" title={moment(@props.comment.timestamp).format 'llll'}>{moment(@props.comment.timestamp).fromNow()}</time>

            {if @props.summary
              if @props.comment.subject?
                <i className="fa fa-picture-o fa-fw"></i>
              else if @props.comment.thread?
                <i className="fa fa-comments fa-fw"></i>}
          </span>

          {unless @props.summary or @props.comment.flagged?
            <ChangeListener target={auth}>{=>
              <PromiseRenderer promise={auth.checkCurrent()}>{(user) =>
                if user?
                  <button type="button" className="secret-button" onClick={@handleFlag}>Report</button>
              }</PromiseRenderer>
            }</ChangeListener>}
        </div>

        {if @props.comment.flagged and not @state.showFlagged
          <p className="content form-help">
            This comment has been reported as inappropriate.{' '}
            <button type="button" className="pill-button" onClick={@showFlagged}>Show anyway</button>
          </p>
        else if @props.summary
          <div className="content">{@props.comment.content}</div>
        else
          <Markdown className="content">{@props.comment.content}</Markdown>}
      </div>
    </div>

  handleFlag: ->
    if confirm 'Really report this comment as inappropriate?'
      @props.reference.child('flagged').set true

  showFlagged: ->
    @setState showFlagged: true
