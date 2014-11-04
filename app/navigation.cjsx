# @cjsx React.DOM

React = require 'react/addons'
{ImmutableOptimizations} = require('react-cursor')

module?.exports = React.createClass
  mixins: [ImmutableOptimizations(['cursor'])]

  displayName: 'Navigation'

  links: [
    {href: '#/', text: 'Home'}
    {href: '#/classify', text: 'Classify'}
    {href: '#/about', text: 'About'}
  ]

  componentDidMount: ->
    window.onhashchange = @onHashChange

  onHashChange: ->
    @props.cursor.set(location.hash)

  link: (data, i) ->
    className = if data.href is @props.cursor.value then 'active' else ''
    <a key={i} href={data.href} className={className}>{data.text}</a>

  render: ->
    links = @links.map(@link)
    <nav className="site-navigation">
      {links}
    </nav>
