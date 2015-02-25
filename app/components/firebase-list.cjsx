React = require 'react'
stingyFirebase = require '../lib/stingy-firebase'

module.exports = React.createClass
  mixins: [stingyFirebase.Mixin]

  getDefaultProps: ->
    items: null # Actually "ref" would be a better name, but it's taken.

  getInitialState: ->
    items: {}
    displayCount: NaN

  componentDidMount: ->
    @bindAsObject @props.items, 'items'

  componentWillUpdate: (nextProps, nextState) ->
    nextState.items ?= {}
    if isNaN @state.displayCount
      nextState.displayCount = Object.keys(nextState.items).length

  render: ->
    itemsKeys = Object.keys @state.items

    <div className="firebase-list">
      {for key in itemsKeys[0...@state.displayCount]
        # We're gonna trust that the object is in order.
        @props.children key, @state.items[key]}

      {if itemsKeys.length > @state.displayCount
        <div>
          <button type="button" className="minor-button" onClick={@displayAll}>Load {itemsKeys.length - @state.displayCount} more</button>
        </div>}
    </div>

  displayAll: ->
    @setState displayCount: @state.items.length
