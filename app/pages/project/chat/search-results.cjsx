React = require 'react'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
PromiseRenderer = require '../../../components/promise-renderer'
{Link} = require 'react-router'
Comment = require './comment'

SEARCH_TIMEOUT = 1500

searchRoot = stingyFirebase.child 'search'

module.exports = React.createClass
  displayName: 'ProjectChatSearchResults'

  mixins: [stingyFirebase.Mixin]

  getInitialState: ->
    results: null
    searchTimeout: NaN

  componentDidMount: ->
    @openSearchFor @props.query.q

  componentWillReceiveProps: (nextProps) ->
    unless nextProps.query.q is @props.query.q
      @openSearchFor nextProps.query.q

  openSearchFor: (query) ->
    results = null

    searchTimeout = setTimeout (=> @setState results: []), SEARCH_TIMEOUT

    @setState {results, searchTimeout}, =>
      requestRef = searchRoot.child('request').push
        index: 'demo_comments'
        query: query_string: {query}
        type: 'comment'

      searchRoot.child("response/#{requestRef.key()}/hits/hits").on 'value', @handleResults

  handleResults: (snap) ->
    results = snap.val()
    if results?
      clearTimeout @state.searchTimeout
      snap.ref().parent().parent().remove()
      @setState {results}

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="content-container">
      {if @state.results?
        if @state.results.length is 0
          <span className="form-help">No results</span>
        else
          # console.log 'Results', @state.results
          for result in @state.results
            <PromiseRenderer key={result._id} promise={stingyFirebase.get "projects/#{@props.project.id}/comments/#{result._id}"}>{(request) =>
              comment = JSON.parse request.responseText
              # console.log 'Comment', comment
              if comment?
                linkParams = Object.create @props.params
                linkParams.subjectID = comment.subject
                linkParams.threadID = comment.thread

                linkTo = if 'subject' of comment
                  'subject-details'
                else if 'thread' of comment
                  'project-chat-thread'

                <Link to={linkTo} params={linkParams} className="secret-button full">
                  <Comment comment={comment} reference={commentsRef.child result._id} summary />
                </Link>
              else
                <span className="form-help warning">Missing comment</span>
            }</PromiseRenderer>
      else
        <span>Searching...</span>}
    </div>
