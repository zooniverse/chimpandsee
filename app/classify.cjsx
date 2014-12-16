React = require 'react/addons'
cx = React.addons.classSet

Subject = require 'zooniverse/models/subject'
Annotation = require './annotation/annotation'
SlideTutorial = require './slideTutorial'
Guide = require './guide'

module?.exports = React.createClass
  displayName: 'Classify'

  getInitialState: ->
    subject: "http://placehold.it/300&text=loading"
    preview: [
      "http://placehold.it/300x150&text=video-preview-1"
      "http://placehold.it/300x150&text=video-preview-2"
      "http://placehold.it/300x150&text=video-preview-3"
      "http://placehold.it/300x150&text=video-preview-4"
      "http://placehold.it/300x150&text=video-preview-5"
      "http://placehold.it/300x150&text=video-preview-6"
      "http://placehold.it/300x150&text=video-preview-7"
      "http://placehold.it/300x150&text=video-preview-8"
      "http://placehold.it/300x150&text=video-preview-9"
    ]
    guideIsOpen: false
    modalIsOpen: false

  componentWillMount: ->
    Subject.on 'select', @onSubjectSelect
    Subject.next()

  componentWillUnmount: ->
    Subject.off 'select', @onSubjectSelect
    wrapper = document.getElementById('wrapper')
    wrapper.classList.remove 'push-right'

  onSubjectSelect: (e, subject) ->
    @setState subject: subject.location.standard

  toggleGuide: (e) ->
    # Grabbing DOM element outside of React components to be able to move everything to the right including top bar and footer
    wrapper = document.getElementById('wrapper')

    if @state.guideIsOpen is false
      @setState guideIsOpen: true
      wrapper.classList.add 'push-right'
    else
      @onClickClose()

  onClickClose: ->
    wrapper = document.getElementById('wrapper')

    @setState guideIsOpen: false
    wrapper.classList.remove 'push-right'

  openModal: ->
    @setState modalIsOpen: true

  closeModal: ->
    @setState modalIsOpen: false

  render: ->
    <div className="classify content">
      <button className="tutorial-btn" onClick={@openModal}>Tutorial</button>

      <Guide onClickClose={@onClickClose} guideIsOpen={@state.guideIsOpen} />
      <Annotation subject={@state.subject} preview={@state.preview} toggleGuide={@toggleGuide} guideIsOpen={@state.guideIsOpen} />
      <SlideTutorial modalIsOpen={@state.modalIsOpen} onClickCloseSlide={@closeModal} />
      <img className="hidden-chimp" src="./assets/hidden-chimp.png" alt="" />
    </div>
