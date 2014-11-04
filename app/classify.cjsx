# @cjsx React.DOM

React = require 'react/addons'
Subject = require 'zooniverse/models/subject'

module?.exports = React.createClass
  displayName: 'Classify'

  onClickNextSubject: ->
    Subject.next()

  render: ->
    <div className="classify">
      <h1>Classify Page</h1>
      <img src={@props.cursor.refine('subject').value ? ""} />
      <button className="next-subject-btn" onClick={@onClickNextSubject}>Next Subject</button>
    </div>

