React = require 'react'
DrawingToolRoot = require './root'
Draggable = require '../../lib/draggable'
DeleteButton = require './delete-button'
DragHandle = require './drag-handle'
Polygon = require './polygon'

console.dir Polygon
module.exports = React.createClass
  displayName: 'MultiPointTool'

  statics: Polygon.statics
  
  render: ->
    console.log "PROPs", @props

    <Polygon {...@props} showGuideline={false} points={2}> </Polygon>
    