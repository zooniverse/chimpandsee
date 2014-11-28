React = require 'react/addons'

module?.exports = React.createClass
  displayName: 'Navigation'

  links: [
    {href: '#/classify', text: 'Explore'}
    {href: '#/about', text: 'About'}
    {href: '#', text: 'Talk'}
    {href: '#', text: 'Blog' }
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
      <a href="#/"><img className="logo" src="http://placehold.it/160x45&text=site-logo" alt="logo" /></a>
      {links}
    </nav>
