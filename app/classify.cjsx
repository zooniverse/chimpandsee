React = require 'react/addons'
cx = React.addons.classSet

Annotation = require './annotation/annotation'
SlideTutorial = require './slideTutorial'
Guide = require './guide'

Subject = require 'zooniverse/models/subject'
Favorite = require 'zooniverse/models/favorite'
Classification = require 'zooniverse/models/classification'

module?.exports = React.createClass
  displayName: 'Classify'

  getInitialState: ->
    subject: "http://placehold.it/300&text=loading"
    previews: []
    classification: null
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
    @setState previews: subject.location.previews
    @setState classification: new Classification {subject}

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
      <Annotation subject={@state.subject} previews={@state.previews} classification={@state.classification} toggleGuide={@toggleGuide} guideIsOpen={@state.guideIsOpen} />
      <SlideTutorial modalIsOpen={@state.modalIsOpen} onClickCloseSlide={@closeModal} />
      <img className="hidden-chimp" src="./assets/hidden-chimp.png" alt="" />
    </div>
