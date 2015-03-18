React = require 'react'
Tether = require 'tether/tether'

DEFAULT_ATTACHMENT_POINT = 'middle center'

module.exports = React.createClass
  displayName: 'Tooltip'

  getDefaultProps: ->
    attachment: 'middle center'
    targetAttachment: 'middle center'
    offset: '0 0'
    targetOffset: '0 0'
    pin: false
    arrowStyle: null

  getInitialState: ->
    if @props.onExit
      autoCloser = document.createElement 'div'
      autoCloser.classList.add 'tooltip-auto-closer'

    container = document.createElement 'div'
    container.classList.add 'tooltip-container'

    autoCloser: autoCloser
    container: container
    tether: null

  componentDidMount: ->
    if @props.onExit?
      document.body.addEventListener 'keydown', @handleKeyDown
      document.body.appendChild @state.autoCloser
      @state.autoCloser.addEventListener 'click', @props.onExit

    document.body.appendChild @state.container

    @renderTooltip()

    @setState
      tether: new Tether @getTetherOptions()
      =>
        @state.tether.position()
        @toFront()

  componentWillUnmount: ->
    if @props.onExit?
      document.body.removeEventListener 'keydown', @handleKeyDown
      @state.autoCloser.parentNode.removeChild @state.autoCloser
      @state.autoCloser.removeEventListener 'click', @props.onExit

    React.unmountComponentAtNode @state.container

    @state.container.parentNode.removeChild @state.container
    @state.tether.destroy()

  componentDidUpdate: ->
    @renderTooltip()
    @state.tether.setOptions @getTetherOptions()
    @state.tether.position()

  getTetherOptions: ->
    element: @state.container
    target: @getDOMNode().parentNode
    attachment: @props.attachment
    targetAttachment: @props.targetAttachment
    offset: @props.offset
    targetOffset: @props.targetOffset
    constraints: [
      {to: 'window', pin: @props.pin}
    ]

  render: ->
    <noscript className="tooltip-anchor"></noscript>

  renderTooltip: ->
    React.render <div className="tooltip" onClick={@toFront}>
      <div className="arrow" style={@props.arrowStyle}></div>
      <div className="content">
        {@props.children}
      </div>
    </div>, @state.container

  toFront: ->
    if @state.container.nextSibling?
      @state.container.parentNode.appendChild @state.container

  handleKeyDown: (e) ->
    if e.which is 27 # Esc
      @props.onExit e
