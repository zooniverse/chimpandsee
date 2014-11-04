# @cjsx React.DOM

init = require './init'
React = require 'react/addons'
{Router, Routes, Route, Link} = require 'react-router'
Cursor = require('react-cursor').Cursor

Navigation = require './navigation'
Home = require './home'
Classify = require './classify'
About = require './about'

User = require 'zooniverse/models/user'
Subject = require 'zooniverse/models/subject'
Classification = require 'zooniverse/models/classification'

Main = React.createClass
  displayName: 'Main'

  componentWillMount: ->
    Subject.on 'select', @onSubjectSelect
    User.on 'change', @onUserChange
    User.fetch()

  getInitialState: ->
    user: User
    navigation:
      activePage: location.hash
    classify:
      subject: null

  render: ->
    cursor = Cursor.build(@)
    window.cur = cursor

    <div>
      <Navigation cursor={cursor.refine('navigation', 'activePage')} />

      <Routes>
        <Route path="/" name="root" handler={Home} />
        <Route path="/classify" handler={Classify} cursor={cursor.refine('classify')} />
        <Route path="/about" handler={About} />
      </Routes>
    </div>

  onSubjectSelect: (e, subject) ->
    @setState classify: subject: subject.location.standard

  onUserChange: (e, user) ->
    Subject.next()

React.render Main(null), document.getElementById("app")
window.React = React
