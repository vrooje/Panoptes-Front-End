React = require 'react'
stingyFirebase = require '../lib/stingy-firebase'

module.exports = React.createClass
  mixins: [stingyFirebase.Mixin]

  getDefaultProps: ->
    tag: 'div'
    items: null # Actually "ref" would be a better name, but it's taken.
    reverse: false
    empty: 'No items'

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
    if @props.reverse
      itemsKeys.reverse()

    items = if @state.displayCount is 0
      @props.empty

    else
      for key in itemsKeys[0...@state.displayCount]
        # We're gonna trust that the object is in order.
        @props.children key, @state.items[key]

    loadMoreButton = if itemsKeys.length > @state.displayCount
      <button type="button" className="minor-button" onClick={@displayAll}>Load {itemsKeys.length - @state.displayCount} more</button>

    children = if @props.reverse
      {loadMoreButton, items}
    else
      {items, loadMoreButton}

    React.createElement @props.tag, className: 'firebase-list', children

  displayAll: ->
    @setState displayCount: @state.items.length
