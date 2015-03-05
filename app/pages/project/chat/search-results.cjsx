React = require 'react'
FirebaseList = require '../../../components/firebase-list'
stingyFirebase = require '../../../lib/stingy-firebase'
Comment = require './comment'

searchRoot = stingyFirebase.root.parent().child 'search'

module.exports = React.createClass
  displayName: 'ProjectChatSearchResults'

  getInitialState: ->
    resultsRef: null
    results: null

  componentDidMount: ->
    @openSearchFor @props.query.q

  componentWillUnmount: ->
    @closeSearch()

  componentWillReceiveProps: (nextProps) ->
    unless nextProps.query.q is @props.query.q
      @openSearchFor nextProps.query.q

  openSearchFor: (query) ->
    @closeSearch()

    console?.log 'Will search for:', query

    requestRef = searchRoot.child('request').push
      index: 'demo_comments'
      query: query_string: {query}
      type: 'comment'

    @setState resultsRef: searchRoot.child('response').child(requestRef.key()), =>
      @state.resultsRef.on 'value', @updateResults

  closeSearch: ->
    if @state.resultsRef?
      console?.log 'Ending search', @state.resultsRef.key()
      @state.resultsRef.off 'value', @updateResults

  updateResults: (snap) ->
    value = snap.val()
    console?.log 'Got search results', value
    if value?
      @setState results: value

  render: ->
    commentsRef = stingyFirebase.child "projects/#{@props.project.id}/comments"

    <div className="content-container">
      <pre>{JSON.stringify @state.results, null, 2}</pre>
    </div>
