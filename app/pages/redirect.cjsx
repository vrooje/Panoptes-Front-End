React = require 'react'
{Navigation} = require 'react-router'

module.exports = (name, navigationArgs...) ->
  React.createClass
    displayName: 'Redirect'

    mixins: [Navigation]

    componentDidMount: ->
      newPath = if name.indexOf('//') is -1
        location.pathname + location.search + @makeHref name, navigationArgs...
      else
        name

      location.replace newPath

    render: ->
      <code>Redirect to {name} {JSON.stringify navigationArgs}</code>
