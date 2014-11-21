init = require './init'
React = require 'react/addons'
{Router, Routes, Route, Link} = require 'react-router'

Navigation = require './navigation'
Home = require './home'
Classify = require './classify'
About = require './about'

User = require 'zooniverse/models/user'

Main = React.createClass
  displayName: 'Main'

  render: ->
    <div>
      <Navigation />

      <Routes>
        <Route path="/" name="root" handler={Home} />
        <Route path="/classify" handler={Classify} />
        <Route path="/about" handler={About} />
      </Routes>
    </div>

React.render <Main />, document.getElementById("app")
window.React = React
