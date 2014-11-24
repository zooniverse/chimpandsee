React = require 'react/addons'

module?.exports = React.createClass
  displayName: 'Navigation'

  links: [
    {href: '#/', text: 'Home'}
    {href: '#/classify', text: 'Classify'}
    {href: '#/about', text: 'About'}
  ]

  getInitialState: ->
    activeLink: location.hash

  componentDidMount: ->
    window.onhashchange = @onHashChange

  onHashChange: ->
    @setState activeLink: location.hash

  link: (data, i) ->
    className = if data.href is @state.activeLink then 'active' else ''
    <li key={i} className={className}><a href={data.href}>{data.text}</a></li>

  render: ->
    links = @links.map(@link)
    <nav className="site-navigation">
      {links}
    </nav>
