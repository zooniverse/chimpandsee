React = require 'react/addons'
cx = React.addons.classSet

{Link} = require 'react-router'

GenericAboutPage = require './generic-about-page'
Authors = require './authors'
aboutContent = require '../lib/aboutContent'

module?.exports = React.createClass
  displayName: 'About'

  getInitialState: ->
    links: [
      { href: "about", name: "About" }
      { href: "team", name: "Team" }
      { href: "organizations", name: "Organizations" }
      { href: "authors", name: "Authors" }
    ]
    pageContent: aboutContent
    activeContent: 0

  componentWillMount: ->
    if window.location.hash is '#/about/team'
      @setState activeContent: 1
    else if window.location.hash is '#/about/organizations'
      @setState activeContent: 2
    else if window.location.hash is '#/about/authors'
      @setState activeContent: 3

  componentWillReceiveProps: (nextProps) ->
    if nextProps.hash is '#/about' then @setState activeContent: 0

  onLinkClick: (i) ->
    @setState activeContent: i

  render: ->
    navLinkClasses = cx
      'about-link': window.location.hash isnt '#/about'

    links = @state.links.map (link, i) =>
      <Link key={i} to={link.href} className={navLinkClasses if link.href is 'about'} onClick={@onLinkClick.bind(null, i)}>{link.name}</Link>

    <div className="about">
      <section className="about-hero">
        <h2>About<br /><img className="logo" src="./assets/chimpnsee-logo.svg" alt="logo" /></h2>
      </section>
      <nav className="about-nav">
        <div className="content">
          {links}
        </div>
      </nav>
      {if @state.activeContent isnt 3
        <GenericAboutPage activeContent={@state.activeContent} pageContent={@state.pageContent[@state.activeContent]} />}
      {if @state.activeContent is 3
        <Authors pageContent={@state.pageContent[@state.activeContent]} />}
    </div>