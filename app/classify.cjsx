React = require 'react/addons'
Subject = require 'zooniverse/models/subject'

module?.exports = React.createClass
  displayName: 'Classify'

  getInitialState: ->
    subject: "http://placehold.it/300&text=loading"

  componentWillMount: ->
    Subject.on 'select', @onSubjectSelect
    Subject.next()

  componentWillUnmount: ->
    Subject.off 'select', @onSubjectSelect

  onSubjectSelect: (e, subject) ->
    @setState subject: subject.location.standard

  onClickNextSubject: ->
    Subject.next()

  render: ->
    <div className="classify">
      <h1>Classify Page</h1>
      <img src={@state.subject} />
      <button className="next-subject-btn" onClick={@onClickNextSubject}>Next Subject</button>
    </div>
