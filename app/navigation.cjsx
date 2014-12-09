React = require 'react/addons'
{Link} = require 'react-router'

module?.exports = React.createClass
  displayName: 'Navigation'

  links: [
    {href: 'classify', text: 'Explore'}
    {href: 'about', text: 'About'}
  ]

  link: (data, i) ->
    <Link key={i} to={data.href}>{data.text}</Link>

  render: ->
    links = @links.map(@link)
    <nav className="site-navigation">
      <a href="#/"><img className="logo" src="http://placehold.it/160x45&text=site-logo" alt="logo" /></a>
      {links}
      <a href="#">Talk</a>
      <a href="#">Blog</a>
    </nav>
