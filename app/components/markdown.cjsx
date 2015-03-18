React = require 'react'
MarkdownIt = require 'markdown-it'
MarkdownItContainer = require 'markdown-it-container'

markdownIt = new MarkdownIt
markdownIt.use require 'markdown-it-emoji'
markdownIt.use require 'markdown-it-sub'
markdownIt.use require 'markdown-it-sup'
markdownIt.use require 'markdown-it-footnote'
markdownIt.use MarkdownItContainer, 'attribution'
markdownIt.use MarkdownItContainer, 'figure'
markdownIt.use MarkdownItContainer, 'partners'

module.exports = React.createClass
  displayName: 'Markdown'

  propTypes:
    children: React.PropTypes.string

  getDefaultProps: ->
    tag: 'div'
    inline: false

  render: ->
    markup = if @props.inline
      markdownIt.renderInline @props.children
    else
      markdownIt.render @props.children

    React.createElement @props.tag,
      className: "markdown #{@props.className ? ''}"
      dangerouslySetInnerHTML: __html: markup
