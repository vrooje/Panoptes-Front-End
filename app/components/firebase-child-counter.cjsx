React = require 'react'
Firebase = require 'firebase'

root = new Firebase 'https://panoptes-comments.firebaseio.com'

module.exports = React.createClass
  displayName: 'FirebaseChildCounter'

  getDefaultProps: ->
    path: null

  getInitialState: ->
    ref: null
    count: 0

  componentDidMount: ->
    @setState ref: root.child(@props.path), =>
      window.ref = @state.ref
      @state.ref.on 'value', @handleChildrenUpdate

  componentWillUnmount: ->
    @state.ref.off 'value', @handleChildrenUpdate

  handleChildrenUpdate: (snap) ->
    @setState count: snap.numChildren()

  render: ->
    <span {...@props}>{@state.count}</span>
