init = require './init'
React = require 'react/addons'
Router = require 'react-router'
{Route, RouteHandler, DefaultRoute, Link} = require 'react-router'

Navigation = require './navigation'
Home = require './home'
Classify = require './classify'
About = require './about'

User = require 'zooniverse/models/user'

# Require main.styl for webpack
require '../css/main.styl'

Main = React.createClass
  displayName: 'Main'

  render: ->
    <div>
      <Navigation />

      <RouteHandler />
    </div>

routes =
  <Route name="root" path="/" handler={Main}>
    <Route name="classify" path="classify" handler={Classify} />
    <Route name="about" path="about" handler={About}>
      <Route name="team" path="team" handler={About} />
      <Route name="organizations" path="organizations" handler={About} />
    </Route>

    <DefaultRoute handler={Home} />
  </Route>

Router.run routes, (Handler) ->
  React.render <Handler />, document.getElementById("app")

window.React = React
