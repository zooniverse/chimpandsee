React = require 'react/addons'
cx = React.addons.classSet

Subject = require 'zooniverse/models/subject'
Annotation = require './annotation/annotation'
SlideTutorial = require './slideTutorial'
Guide = require './guide'

animatedScrollTo = require 'animated-scrollto'

steps = require './lib/steps'

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
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
      "http://placehold.it/300x150&text=video-preview"
    ]
    guideIsOpen: false
    modalIsOpen: false

  componentWillMount: ->
    Subject.on 'select', @onSubjectSelect
    Subject.next()

  componentWillUnmount: ->
    Subject.off 'select', @onSubjectSelect

  onSubjectSelect: (e, subject) ->
    @setState subject: subject.location.standard

  toggleGuide: (e) ->
    # Grabbing DOM element outside of React components to be able to move everything to the right including top bar and footer
    wrapper = document.getElementById('wrapper')

    if @state.guideIsOpen is false
      @setState guideIsOpen: true
      wrapper.classList.add 'push-right'
    else
      console.log @refs
      @setState guideIsOpen: false
      wrapper.classList.remove 'push-right'

  onClickClose: ->
    wrapper = document.getElementById('wrapper')

    @setState guideIsOpen: false
    wrapper.classList.remove 'push-right'

  openModal: ->
    @setState modalIsOpen: true

  closeModal: ->
    @setState modalIsOpen: false

  render: ->
    <div className="classify">
      <button className="tutorial-btn" onClick={@openModal}>Tutorial</button>

      <Guide onClickClose={@onClickClose} />
      <Annotation subject={@state.subject} preview={@state.preview} toggleGuide={@toggleGuide} guideIsOpen={@state.guideIsOpen} />
      <SlideTutorial modalIsOpen={@state.modalIsOpen} onClickCloseSlide={@closeModal} />
      <img className="hidden-chimp" src="./assets/hidden-chimp.png" alt="" />
    </div>
