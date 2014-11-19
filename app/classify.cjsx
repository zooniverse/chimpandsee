React = require 'react/addons'
Subject = require 'zooniverse/models/subject'
Annotation = require './annotation/annotation'

module?.exports = React.createClass
  displayName: 'Classify'

  getInitialState: ->
    subject: "http://placehold.it/300&text=loading"
    preview: [
      "http://placehold.it/150&text=video-preview"
      "http://placehold.it/150&text=video-preview"
      "http://placehold.it/150&text=video-preview"
      "http://placehold.it/150&text=video-preview"
      "http://placehold.it/150&text=video-preview"
      "http://placehold.it/150&text=video-preview"
    ]

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
      <Annotation subject={@state.subject} preview={@state.preview} />
    </div>
