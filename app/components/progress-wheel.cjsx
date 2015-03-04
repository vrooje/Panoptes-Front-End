React = require 'react'

module.exports = React.createClass
  displayName: 'ProgressWheel'

  getDefaultProps: ->
    value: 0

  render: ->
    largeArc = if @props.value > 0.5 then 1 else 0
    endX = 40 * Math.cos(Math.PI * 2 * @props.value).toFixed 3
    endY = -40 * Math.sin(Math.PI * 2 * @props.value).toFixed 3

    <svg {...@props} className="progress-wheel" viewBox="0 0 100 100">
      <g transform="translate(50, 50) scale(-1, 1) rotate(-90)" fill="none" stroke="none" strokeWidth="0">
        <circle className="disc" r="40" />
        <path className="wedge" d="M 0 0 L 40 -0.001 A 40 40 0 #{largeArc} 0 #{endX} #{endY} Z" />
        <path className="arc" d="M 40 -0.001 A 40 40 0 #{largeArc} 0 #{endX} #{endY}" />
      </g>
    </svg>
