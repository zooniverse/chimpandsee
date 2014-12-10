React = require 'react/addons'
cx = React.addons.classSet

{Link} = require 'react-router'

module?.exports = React.createClass
  displayName: 'About'

  getInitialState: ->
    links: [
      { href: "about", name: "About" }
      { href: "team", name: "Team" }
      { href: "organizations", name: "Organizations" }
    ]
    pageContent: [
      "About default: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      "About team: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
      "About organizations: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    ]
    activeContent: 0

  onLinkClick: (i) ->
    @setState activeContent: i

  render: ->
    navLinkClasses = cx({
      'about-link': window.location.hash isnt '#/about'
    })

    links = @state.links.map (link, i) =>
      <Link key={i} to={link.href} className={navLinkClasses if link.href is 'about'} onClick={@onLinkClick.bind(null, i)}>{link.name}</Link>

    <div className="about content">
      <h1>About Page</h1>
      <nav className="about-nav">
        {links}
      </nav>
      <section>
        <p>{@state.pageContent[@state.activeContent]}</p>
      </section>
    </div>