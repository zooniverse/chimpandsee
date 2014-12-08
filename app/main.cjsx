init = require './init'
React = require 'react/addons'
Router = require 'react-router'
{Route, RouteHandler, DefaultRoute, Link} = require 'react-router'

Navigation = require './navigation'
Home = require './home'
Classify = require './classify'
About = require './about'

User = require 'zooniverse/models/user'

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
    <Route path="/classify" handler={Classify} />
    <Route path="/about" handler={About} />
    <DefaultRoute handler={Home} />
  </Route>

Router.run routes, (Handler) ->
  React.render <Handler />, document.getElementById("app")

window.React = React
