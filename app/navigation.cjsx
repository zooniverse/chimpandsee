React = require 'react/addons'
cx = React.addons.classSet

{Link} = require 'react-router'

module?.exports = React.createClass
  displayName: 'Navigation'

  links: [
    {href: 'classify', text: 'Explore'}
    {href: 'about', text: 'About'}
    {href: 'profile', text: 'Profile'}
  ]

  link: (data, i) ->
    <Link key={i} to={data.href}>{data.text}</Link>

  render: ->
    links = @links.map(@link)

    zooInfoClasses = cx({
      'zooniverse-info': true
      'hide': unless @props.user? then true else false
    })
    <nav className="site-navigation">
      <a href="#/"><img className="logo" src="./assets/chimp-zoo.svg" alt="logo" /></a>
      {links}
      <a href="#">Talk</a>
      <a href="#">Blog</a>
      <div className={zooInfoClasses}>
        <svg xmlns="http://www.w3.org/2000/svg" className="zooniverse-logo" viewBox="0 0 100 100" width="1em" height="1em">
          <g fill="currentColor" stroke="transparent" strokeWidth="0" transform="translate(50, 50)">
            <path d="M 0 -45 A 45 45 0 0 1 0 45 A 45 45 0 0 1 0 -45 Z M 0 -30 A 30 30 0 0 0 0 30 A 30 30 0 0 0 0 -30 Z" />
            <path d="M 0 -12.5 A 12.5 12.5 0 0 1 0 12.5 A 12.5 12.5 0 0 1 0 -12.5 Z" />
            <path d="M 0 -75 L 5 0 L 0 75 L -5 0 Z" transform="rotate(50)" />
          </g>
        </svg>
        <span>A Zooniverse project</span>
      </div>
    </nav>
