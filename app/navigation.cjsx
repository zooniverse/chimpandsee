React = require 'react/addons'
cx = React.addons.classSet

{Link} = require 'react-router'

module?.exports = React.createClass
  displayName: 'Navigation'

  getInitialState: ->
    showMobileMenu: false

  toggleMobileMenu: ->
    @setState showMobileMenu: !@state.showMobileMenu

  links: [
    {href: 'classify', text: 'Explore'}
    {href: 'about', text: 'About'}
    {href: 'profile', text: 'Profile'}
  ]

  componentWillReceiveProps: (nextProps) ->
    if nextProps isnt window.location.hash then @setState showMobileMenu: false

  link: (data, i) ->
    <Link key={i} to={data.href}>{data.text}</Link>

  render: ->
    links = @links.map(@link)

    navClasses = cx
      'site-navigation': true
      'color-background': @state.showMobileMenu is true

    menuClasses = cx
      'menu-list': true
      'show-menu green-background': @state.showMobileMenu is true

    <nav className={navClasses}>
      <div className="mobile-menu" onClick={@toggleMobileMenu}>
        <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" viewBox="0 0 30 30">
          <g>
            <rect className="bars" y="2.5" width="30" height="5"/>
            <rect className="bars" y="12.5" width="30" height="5"/>
            <rect className="bars" y="22.5" width="30" height="5"/>
          </g>
        </svg>
      </div>
      <a href="#/" className="logo-link"><img className="logo" src={if window.location.hash is '#/' then "./assets/chimp-logo-home.png" else "./assets/chimp-logo.png"} alt="logo" /></a>
      <div className={menuClasses}>
        {links}
        <a href="#">Talk</a>
        <a href="#">Blog</a>
      </div>
      {if @props.user?
        <div className="zooniverse-info">
          <svg xmlns="http://www.w3.org/2000/svg" className="zooniverse-logo" viewBox="0 0 100 100" width="1em" height="1em">
            <g fill="currentColor" stroke="transparent" strokeWidth="0" transform="translate(50, 50)">
              <path d="M 0 -45 A 45 45 0 0 1 0 45 A 45 45 0 0 1 0 -45 Z M 0 -30 A 30 30 0 0 0 0 30 A 30 30 0 0 0 0 -30 Z" />
              <path d="M 0 -12.5 A 12.5 12.5 0 0 1 0 12.5 A 12.5 12.5 0 0 1 0 -12.5 Z" />
              <path d="M 0 -75 L 5 0 L 0 75 L -5 0 Z" transform="rotate(50)" />
            </g>
          </svg>
          <span>A Zooniverse project</span>
        </div>}
    </nav>
