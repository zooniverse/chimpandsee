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
    <a key={i} href={data.href} className={className}>{data.text}</a>

  render: ->
    links = @links.map(@link)
    <nav className="site-navigation">
      {links}
    </nav>
