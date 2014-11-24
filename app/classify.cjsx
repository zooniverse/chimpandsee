React = require 'react/addons'
Subject = require 'zooniverse/models/subject'
Annotation = require './annotation/annotation'

module?.exports = React.createClass
  displayName: 'Classify'

  getInitialState: ->
    subject: "http://placehold.it/300&text=loading"
    preview: [
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
    ]
    showGuide: false

  componentWillMount: ->
    Subject.on 'select', @onSubjectSelect
    Subject.next()

  componentWillUnmount: ->
    Subject.off 'select', @onSubjectSelect

  onSubjectSelect: (e, subject) ->
    @setState subject: subject.location.standard

  onClickGuide: (e) ->
    # Grabbing DOM element outside of React components to be able to move everything to the right including top bar and footer
    wrapper = document.getElementById('wrapper')

    if @state.showGuide is false
      @setState showGuide: true
      wrapper.classList.add 'push-right'
    else
      @setState showGuide: false
      wrapper.classList.remove 'push-right'

  onClickClose: ->
    wrapper = document.getElementById('wrapper')

    @setState showGuide: false
    wrapper.classList.remove 'push-right'

  render: ->
    <div className="classify">
      <h1>Classify Page</h1>
      <div className="guide">
        <h2>Field Guide</h2>
        <button className="close-guide-btn" onClick={@onClickClose}>X</button>
      </div>
      <Annotation subject={@state.subject} preview={@state.preview} onClickGuide={@onClickGuide} />
    </div>
