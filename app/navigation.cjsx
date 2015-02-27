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
      <a href="#/" className="logo-link"><img className="logo" src="./assets/chimpnsee-logo.svg" alt="logo" /></a>
      <div className={menuClasses}>
        {links}
        <a href="https://docs.google.com/a/zooniverse.org/forms/d/1OF4FwFcLp6UThhFXS2lRKYhO5McRsSzhS9h5i3g9ZJ0/viewform" target="_blank">Survey</a>
      </div>
    </nav>
