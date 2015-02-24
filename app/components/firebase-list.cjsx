React = require 'react'
stingyFirebase = require '../lib/stingy-firebase'

module.exports = React.createClass
  mixins: [stingyFirebase.Mixin]

  getDefaultProps: ->
    items: null

  getInitialState: ->
    items: []
    displayCount: NaN

  componentDidMount: ->
    @bindAsObject @props.items, 'items'

  componentWillUpdate: (nextProps, nextState) ->
    if isNaN @state.displayCount
      nextState.displayCount = nextState.items.length

  render: ->
    ItemComponent = @props.render

    <div className="firebase-list">
      {for key in Object.keys(@state.items)[0...@state.displayCount]
        # We're gonna trust that the object is in order.
        @props.children key, @state.items[key]}

      {if @state.items.length > @state.displayCount
        <div>
          <button type="button" className="minor-button" onClick={@displayAll}>Load {@state.items.length - @state.displayCount} more</button>
        </div>}
    </div>

  displayAll: ->
    @setState displayCount: @state.items.length
